# frozen_string_literal: true

class Rack::Attack
  # Always allow requests from localhost in development
  safelist('allow-localhost') do |req|
    ['127.0.0.1', '::1'].include?(req.ip) if Rails.env.development?
  end

  # Allow requests from health check endpoints
  safelist('allow-health-check') do |req|
    req.path == '/up'
  end

  # Throttle API requests by IP address
  throttle('api/ip', limit: 100, period: 1.hour) do |req|
    req.ip if req.path.start_with?('/api') || api_request?(req)
  end

  # Throttle API requests by API key
  throttle('api/key', limit: 500, period: 1.hour) do |req|
    if api_request?(req)
      extract_api_key(req)
    end
  end

  # Aggressive throttling for authentication endpoints
  throttle('auth/ip', limit: 5, period: 1.minute) do |req|
    req.ip if req.path.include?('auth') || req.path.include?('login')
  end

  # Block repeated requests that hit 4XX errors
  blocklist('bad-requests') do |req|
    # Track failed requests per IP
    key = "bad-requests:#{req.ip}"
    count = Rails.cache.read(key) || 0
    
    if count > 10
      Rails.logger.warn "Blocking IP #{req.ip} for excessive bad requests"
      true
    end
  end

  # Track response statuses
  self.track('bad-requests') do |req|
    req.ip
  end

  # Custom response for throttled requests
  self.throttled_responder = lambda do |req|
    match_data = req.env['rack.attack.match_data']
    now = match_data[:epoch_time]
    
    headers = {
      'Content-Type' => 'application/json',
      'X-RateLimit-Limit' => match_data[:limit].to_s,
      'X-RateLimit-Remaining' => '0',
      'X-RateLimit-Reset' => (now + match_data[:period]).to_s
    }
    
    body = {
      error: 'Rate limit exceeded',
      message: 'Too many requests. Please try again later.',
      retry_after: match_data[:period],
      status: 429
    }.to_json
    
    [429, headers, [body]]
  end

  # Custom response for blocked requests
  self.blocklisted_responder = lambda do |req|
    [403, {'Content-Type' => 'application/json'}, [{
      error: 'Request blocked',
      message: 'Your IP has been temporarily blocked due to suspicious activity.',
      status: 403
    }.to_json]]
  end

  private

  def self.api_request?(req)
    req.path.start_with?('/sessions', '/timers', '/asanas') ||
    req.env['HTTP_AUTHORIZATION']&.include?('Bearer') ||
    req.params['api_key'].present?
  end

  def self.extract_api_key(req)
    # Extract from Authorization header
    auth_header = req.env['HTTP_AUTHORIZATION']
    if auth_header&.start_with?('Bearer ')
      return auth_header.split(' ').last
    end
    
    # Extract from query parameters
    req.params['api_key']
  end
end

# Enable rack-attack
Rails.application.config.middleware.use Rack::Attack

# Configure cache store for rate limiting
if Rails.env.production?
  Rack::Attack.cache.store = ActiveSupport::Cache::RedisCacheStore.new(url: ENV['REDIS_URL'])
else
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new
end

# Enable logging
ActiveSupport::Notifications.subscribe('rack.attack') do |name, start, finish, request_id, req|
  Rails.logger.info "[Rack::Attack] #{req.env['rack.attack.match_type']} #{req.ip} #{req.request_method} #{req.fullpath}"
end