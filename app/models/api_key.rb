class ApiKey < ApplicationRecord
  has_secure_token :key, length: 32
  
  validates :name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :key_digest, presence: true, on: :update
  validates :key, presence: true, on: :create
  
  before_create :set_key_digest
  before_create :set_default_expiration
  
  scope :active, -> { where(active: true) }
  scope :valid, -> { where('expires_at IS NULL OR expires_at > ?', Time.current) }
  
  def self.authenticate(key)
    return nil unless key
    
    digest = Digest::SHA256.hexdigest(key)
    find_by(key_digest: digest)&.tap do |api_key|
      return nil unless api_key.active?
      return nil if api_key.expires_at && api_key.expires_at < Time.current
    end
  end
  
  def expired?
    expires_at && expires_at < Time.current
  end
  
  def valid_key?
    active? && !expired?
  end
  
  private
  
  def set_key_digest
    self.key_digest = Digest::SHA256.hexdigest(key) if key
  end
  
  def set_default_expiration
    self.expires_at ||= 1.year.from_now
    self.active = true if active.nil?
  end
end
