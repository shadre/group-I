class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  private

  def after_sign_in_path_for(_)
    root_path
  end

  def after_sign_up_path_for(_)
    root_path
  end
end
