class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  
  # Confirms whether a user is logged in.
  def logged_in_user
    if !logged_in?
      # Store where the user is so after they login, they will be brought back to that page
      store_location
      flash[:danger] = "Please log in"
      redirect_to login_url
    end
  end
  
  # Confirms whether something belongs to current user.
  def correct_user
    @user = User.find(params[:id])
    redirect_to(login_url) if !current_user?(@user)
  end
end