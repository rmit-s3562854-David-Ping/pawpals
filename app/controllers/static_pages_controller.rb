class StaticPagesController < ApplicationController
  def home
    if logged_in?
      # For the post form field on the page
      @post  = current_user.posts.build
      # Displays the list of posts of the current user
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end
end
