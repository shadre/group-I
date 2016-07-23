module Tokenable
  extend ActiveSupport::Concern

  included do
    before_create :set_token
  end

  protected

  def set_token
    self.token = loop do
      random_token = SecureRandom.uuid
      break random_token unless self.class.exists?(token: random_token)
    end
  end
end
