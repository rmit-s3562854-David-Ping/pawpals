class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    # If the user exists, is not current activated but is authenticated and the activation is valid
    # Then activate the user and then log in
    if user && !user.activated? && user.authenticated?(:activation, params[:id])

      client = Aws::CognitoIdentityProvider::Client.new(
          region: 'us-west-2',
          credentials: Aws::Credentials.new(Rails.application.credentials.aws[:access_key_id], Rails.application.credentials.aws[:secret_access_key])
      )
        # Activates the users account using the admin api, we do this so we can just send them a link
        resp = client.admin_confirm_sign_up({
                                  user_pool_id: Rails.application.credentials.aws[:aws_cognito_pool_id],
                                  username: user.email,
                              })
      user.activate
      log_in user
      flash[:success] = "Your account is now activated"
    else
      flash[:danger] = "Your activation link is invalid"
    end
    redirect_to root_url
  end

end