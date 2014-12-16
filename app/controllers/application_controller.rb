class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user, :logged_in?, :require_user

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]

    if @current_user
      @current_user
    else
      nil
    end
  end

  def logged_in?
    !!current_user
  end

  def admin?
    logged_in? && current_user.admin == true
  end

  def require_user
    if !logged_in?
      flash[:danger] = "You must be logged in to do that."
      redirect_to sign_in_path
    end
  end
end