module DeviseMacros
  def sign_in_user
    @request.env["devise.mapping"] = Devise.mappings[:user]
    user = create(:bob)
    sign_in user
  end
end

RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include DeviseMacros, type: :controller
end
