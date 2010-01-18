# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  before_filter :require_user

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password

  helper_method :current_user_session, :current_user

  private

  # swiped from http://github.com/binarylogic/authlogic_example/
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  # swiped from http://github.com/binarylogic/authlogic_example/
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

  # swiped from http://github.com/binarylogic/authlogic_example/
  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_user_session_url
      return false
    end
  end

  # swiped from http://github.com/binarylogic/authlogic_example/
  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to account_url
      return false
    end
  end

  # swiped from http://github.com/binarylogic/authlogic_example/
  def store_location
    session[:return_to] = request.request_uri
  end

  # swiped from http://github.com/binarylogic/authlogic_example/
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

end
