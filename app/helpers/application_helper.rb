# Common helpers which will be available to all the views
module ApplicationHelper
  # Returns the title of the page
  def full_title(page_title = '')
    base_title = "Pawpals"
    return page_title.empty? ? base_title : page_title + ' | ' + base_title
  end
end