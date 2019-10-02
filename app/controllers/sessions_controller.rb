class SessionsController < ApplicationController

  def new
  end

  def create
    client = Aws::CognitoIdentityProvider::Client.new(
        region: 'us-west-2',
        credentials: Aws::Credentials.new(Rails.application.credentials.aws[:access_key_id], Rails.application.credentials.aws[:secret_access_key])
    )
    # Find user with their email
    user = User.find_by(email: params[:session][:email].downcase)
    # Check if user exists and authenticated successfully using their password
    if user && user.authenticate(params[:session][:password])
      # Try to authenticate the user through cognito
      begin
        resp = client.initiate_auth({
                                        client_id: Rails.application.credentials.aws[:aws_cognito_app_client_id],
                                        auth_flow: "USER_PASSWORD_AUTH",
                                        auth_parameters: {
                                            "USERNAME" => params[:session][:email].downcase,
                                            "PASSWORD" => params[:session][:password]
                                        }
                                    })
      rescue => e
        # begin
        #   res = client.sign_up({client_id: Rails.application.credentials.aws[:aws_cognito_app_client_id], username: params[:session][:email].downcase, password: params[:session][:password]})
        #   res = client.admin_confirm_sign_up({user_pool_id: Rails.application.credentials.aws[:aws_cognito_pool_id], username: user.email})
        #   log_in user
        #   params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        #   redirect_to root_url and return
        # rescue => e
          flash[:danger] = e.message
          render 'new' and return
        # end
      end

      if resp&.authentication_result
        # Check if the user has been activated
        if user.activated?
          log_in user
          params[:session][:remember_me] == '1' ? remember(user) : forget(user)
          redirect_to root_url and return
        else
          flash[:warning] = "Please activate your account through the link sent to your email."
          redirect_to root_url and return
        end
      else
        flash.now[:danger] = 'Invalid email/password'
        render 'new' and return
      end
    else
      flash.now[:danger] = 'Invalid email/password'
      render 'new' and return
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url, :flash => { :success => "You are now logged out" }
  end
end