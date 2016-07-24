module Tokenable
  extend ActiveSupport::Concern

  included do
    after_initialize :set_token
  end

  protected

  def set_token
    return if self.token
    self.token = loop do
      random_token = SecureRandom.uuid
      break random_token unless self.class.exists?(token: random_token)
    end
  end
end
