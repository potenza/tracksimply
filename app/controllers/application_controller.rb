class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :sites

  private

  def require_user
    redirect_to login_url unless current_user
  end

  def require_admin
    redirect_to sites_path unless current_user && current_user.admin?
  end

  def current_user
    @current_user ||= User.find_by_auth_token(cookies.signed[:auth_token]) if cookies.signed[:auth_token]
  end

  def sites
    @sites ||= current_user && Site.all || [] # needed for navbar
  end
end
