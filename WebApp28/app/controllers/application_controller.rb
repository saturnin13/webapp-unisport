class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  ## Keep the cookie to protect from forgery
  after_action :set_csrf_cookie_for_ng

  def set_csrf_cookie_for_ng
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:first_name,
      :last_name, :email, :password, :password_confirmation) }
  end

  ## Check the cookie in the headers to from forgery
  def verified_request?
    super || valid_authenticity_token?(
      session, request.headers['X-XSRF-TOKEN'])
  end

end
