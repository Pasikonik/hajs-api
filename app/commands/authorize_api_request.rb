# frozen_string_literal: true

class AuthorizeApiRequest
  prepend SimpleCommand

  def initialize(headers = {})
    @headers = headers
  end

  def call
    user
  end

  def user
    @user ||= User.find(decode_auth_token[:user_id]) if decode_auth_token
    @user || errors.add(:token, 'Invalid token') && nil
  end

  def decode_auth_token
    @decode_auth_token ||= JsonWebToken.decode(http_auth_header)
  end

  def http_auth_header
    if @headers['Authorization'].blank?
      errors.add(:token, 'Missing token')
      return nil
    end
    @headers['Authorization'].split(' ').last
  end
end
