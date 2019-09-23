class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    # If the user exists, is not current activated but is authenticated and the activation is valid
    # Then activate the user and then log in
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = "Your account is now activated"
    else
      flash[:danger] = "Your activation link is invalid"
    end
    redirect_to root_url
  end

end