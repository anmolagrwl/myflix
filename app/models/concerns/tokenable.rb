module Tokenable
  extend ActiveSupport::Concern

  included do
    before_create :generate_token
  end

  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end

  def update_token
    self.update_attribute(:token, SecureRandom.urlsafe_base64)
  end
end