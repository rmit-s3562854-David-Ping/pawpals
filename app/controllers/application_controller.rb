class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  
  # Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end
  
  # Confirms the correct user.
  def correct_user
    @user = User.find(params[:id])
    redirect_to(login_url) if !current_user?(@user) && !current_user.admin
  end
end