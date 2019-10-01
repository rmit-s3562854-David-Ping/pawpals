module UsersHelper

  def picture_for(user, size = "sm")
    picture_url = 'blank-profile.png'
    if user.image&.attached?
      picture_url = user.image
    end
    if size === "sm"
      image_tag(picture_url, alt: user.name, class: "ui small image")
    elsif size === "avatar"
      image_tag(picture_url, alt: user.name, class: "ui avatar image")
    end
  end
end