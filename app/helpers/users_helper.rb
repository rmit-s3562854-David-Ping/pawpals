module UsersHelper

  def picture_for(user)
    picture_url = 'blank-profile.png'
    if user.image&.attached?
      picture_url = user.image
    end
    image_tag(picture_url, alt: user.name, class: "user-picture")
  end
end