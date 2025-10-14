class ApplicationController < ActionController::API
  before_action :authenticate_api_key
  
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  rescue_from ActionController::ParameterMissing, with: :parameter_missing
  rescue_from StandardError, with: :internal_server_error
  
  private
  
  def authenticate_api_key
    api_key = extract_api_key
    
    unless api_key
      render_error('API key required', status: :unauthorized)
      return
    end
    
    @current_api_key = ApiKey.authenticate(api_key)
    
    unless @current_api_key
      render_error('Invalid or expired API key', status: :unauthorized)
      return
    end
  end
  
  def extract_api_key
    # Try Authorization header first: "Bearer YOUR_API_KEY"
    if request.headers['Authorization'].present?
      token = request.headers['Authorization'].split(' ').last
      return token if token && token != 'Bearer'
    end
    
    # Fallback to query parameter
    params[:api_key]
  end
  
  def current_api_key
    @current_api_key
  end
  
  def record_not_found(exception)
    render json: {
      error: 'Record not found',
      message: exception.message,
      status: 404
    }, status: :not_found
  end
  
  def record_invalid(exception)
    render json: {
      error: 'Validation failed',
      message: exception.message,
      details: exception.record.errors.full_messages,
      status: 422
    }, status: :unprocessable_entity
  end
  
  def parameter_missing(exception)
    render json: {
      error: 'Missing required parameter',
      message: exception.message,
      status: 400
    }, status: :bad_request
  end
  
  def internal_server_error(exception)
    Rails.logger.error "Internal Server Error: #{exception.message}"
    Rails.logger.error exception.backtrace.join("\n")
    
    render json: {
      error: 'Internal server error',
      message: Rails.env.production? ? 'Something went wrong' : exception.message,
      status: 500
    }, status: :internal_server_error
  end
  
  def render_success(data, status: :ok, message: nil)
    response = { data: data, status: Rack::Utils::SYMBOL_TO_STATUS_CODE[status] }
    response[:message] = message if message
    render json: response, status: status
  end
  
  def render_error(message, status: :bad_request, details: nil)
    response = {
      error: message,
      status: Rack::Utils::SYMBOL_TO_STATUS_CODE[status]
    }
    response[:details] = details if details
    render json: response, status: status
  end
end
