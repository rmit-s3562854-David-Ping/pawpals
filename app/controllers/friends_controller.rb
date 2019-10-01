class FriendsController < ApplicationController
  before_action :check_if_user_logged_in, only: [:index, :create, :add, :reject, :remove, :show]

  def index
  end

  def create
    friend = User.find_by(id: params[:id])
    current_user.friend_request(friend)

    redirect_to friends_path
  end

  def add
    friend = User.find_by(id: params[:id])
    current_user.accept_request(friend)

    redirect_to friends_path
  end

  def reject
    friend = User.find_by(id: params[:id])
    current_user.decline_request(friend)

    redirect_to friends_path
  end

  def remove
    friend = User.find_by(id: params[:id])
    current_user.remove_friend(friend)

    redirect_to user_path(friend)
  end

  def show
  end
end