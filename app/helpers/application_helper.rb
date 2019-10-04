module ApplicationHelper

  def full_title(page_title = '')
    base_title = "PawPals"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def distance(user)
    if user.location
      Google::Maps.distance(user.location, current_user.location)
    end
  end
end