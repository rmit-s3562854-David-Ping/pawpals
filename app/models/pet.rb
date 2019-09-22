class Pet < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :name, presence: true, length: { minimum: 2 }
  validates :gender, presence: true
  validates :birth_date, presence: true
  validates :image,
            presence: true,
            content_type: { in: %w[image/jpeg image/gif image/png], message: "must be a valid image format" },
            size:         { less_than: 5.megabytes, message: "should be less than 5MB" }
end
