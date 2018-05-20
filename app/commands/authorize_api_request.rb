class AuthorizeApiRequest
  prepend SimpleCommand

  def initialize(headers = {})
    @headers = headers
  end

  def call
    user
  end

  attr_reader :header

  def user
    @user ||= User.find(decode_auth_token[:user_id]) if decode_auth_token
    @user || errors.add(:token, 'Invalid token') && nil
  end

  def decode_auth_token
    @decode_auth_token ||= JsonWebToken.decode(http_auth_header)
  end

  def http_auth_header
    errors.add(:token, 'Missing token') unless headers['Authorization'].present?
    headers['Authorization'].split(' ').last
  end
end