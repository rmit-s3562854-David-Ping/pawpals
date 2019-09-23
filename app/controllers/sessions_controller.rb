class SessionsController < ApplicationController

  def new
  end

  def create
    # Find user with their email
    user = User.find_by(email: params[:session][:email].downcase)
    # Check if user exists and authenticated successfully using their password
    if user && user.authenticate(params[:session][:password])
      # Check if the user has been activated
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_to root_url
      else
        flash[:warning] = "Please activate your account through the link sent to your email."
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid email/password'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url, :flash => { :success => "You are now logged out" }
  end
end