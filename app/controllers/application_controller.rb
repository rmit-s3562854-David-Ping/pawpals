class ApplicationController < ActionController::Base
  include SessionsHelper

  protect_from_forgery with: :exception

  # Checks whether the resource being accessed belongs to the user currently logged in,
  # if so then they can most likely edit or delete things on the page
  def is_correct_user
    @user = User.find(params[:id])
    unless current_user?(@user)
      redirect_to(login_url)
    end
  end

  # Checks whether or not the user is logged in, if not then redirect them to the login url
  def check_if_user_logged_in
    unless logged_in?
      flash[:danger] = "Please log in"
      redirect_to login_url
    end
  end
end