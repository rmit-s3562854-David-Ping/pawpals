class UserLocationController < ApplicationController
  skip_before_action :verify_authenticity_token

  # PATCH/PUT /user_location/
  # PATCH/PUT /user_location/.json
  def update
    current_user.set_location(params[:location])
  end

end