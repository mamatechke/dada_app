class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  before_action :authenticate_user!
  allow_browser versions: :modern

  protected

  def after_sign_in_path_for(resource)
    # If onboarding was completed before signup, go to dashboard
    if session[:return_to].present?
      path = session[:return_to]
      session.delete(:return_to)
      path
    else
      # Otherwise go to onboarding
      web_onboarding_step1_path
    end
  end
end
