class StaticPagesController < ApplicationController
  def home
    if logged_in?
      # For the micropost form field on the page
      @micropost  = current_user.microposts.build
      # Displays the list of posts of the current user
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end
end
