module UsersHelper

  # Returns the Gravatar for the given user.
  # def gravatar_for(user, options = { size: 80 })
  #   size         = options[:size]
  #   gravatar_id  = Digest::MD5::hexdigest(user.email.downcase)
  #   gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
  #   image_tag(gravatar_url, alt: user.name, class: "gravatar")
  # end

  def picture_for(user)
    picture_url = user.picture.nil? || user.picture.empty? ? 'blank-profile.png' : user.picture
    image_tag(picture_url, alt: user.name, class: "user-picture")
  end
end