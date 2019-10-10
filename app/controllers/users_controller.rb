class UsersController < ApplicationController
  before_action :set_user,       only: [:show, :edit, :update, :destroy]
  before_action :check_if_user_logged_in, only: [:index, :edit, :update]
  before_action :is_correct_user,   only: [:edit, :update]

  # GET /users
  # GET /users.json
  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    @posts = @user.posts.paginate(page: params[:page])
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    if @user.save
      # Create the client object to interact with AWS Cognito, sets the region
      client = Aws::CognitoIdentityProvider::Client.new(region: 'us-west-2')
      begin
        # Attempt to sign up with the provided email and password
        resp = client.sign_up({
                                  client_id: Rails.application.credentials.aws[:aws_cognito_app_client_id],
                                  username: @user.email,
                                  password: @user.password_digest
                              })
        if resp
          @user.send_activation_email
          flash[:info] = "Please check your email to activate your account."
          redirect_to root_url
        end
      rescue Aws::SES::Errors::MessageRejected => e
        @user.destroy
        flash[:danger] = e.message
        render 'new' and return
      rescue => e
        @user.destroy
        flash[:danger] = e.message
        render 'new' and return
      end
    else
      render 'new'
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
        flash[:success] = "Profile updated"
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :image)
    end

    def restrict_access
      head :unauthorized unless params[:access_token] == 'hello'
    end

end
