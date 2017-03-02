class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :check_current_user
  def current_user
      current_user ||= User.where("id = ? and activation_status = ?", session[:user], 'active').first
  end

  def check_current_user
      if current_user.blank?
          flash[:error] = "plase login first before run the action"
          redirect_to new_session_url
      else
          current_user
      end
  end

end
