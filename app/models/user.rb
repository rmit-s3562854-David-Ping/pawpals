class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :pets, class_name: "Pet", foreign_key: "user_id"
  attr_accessor :remember_token, :activation_token
  has_one_attached :image

  before_save   :downcase_email
  before_create :create_activation_digest
  validates :name,  presence: true, length: { minimum: 4, maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  LOWER_CASE_REGEX = /.*[a-z].*/
  UPPER_CASE_REGEX = /.*[A-Z].*/
  NUMBER_REGEX = /.*\d.*/
  SPECIAL_CHAR_REGEX = /.*[!@#$%^&*()].*/
   
  validates :email, presence: true, length: { minimum: 4, maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password,  presence: true,
                        length: { minimum: 8 },
                        allow_nil: true,
                        format: { with: LOWER_CASE_REGEX && UPPER_CASE_REGEX && NUMBER_REGEX && SPECIAL_CHAR_REGEX, message: "must contains at least a lowercase letter, a uppercase, a digit, a special character and 8+ characters" }

  validates :image,
            content_type: { in: %w[image/jpeg image/gif image/png], message: "must be a valid image format" },
            size:         { less_than: 5.megabytes, message: "should be less than 5MB" }

  has_friendship



  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Activates an account.
  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def feed
    Post.where("user_id = ?", id)
  end

  def friends?
    self.friends
  end

  def friend_requests?
    self.requested_friends.any?
  end

  def requested_friends?
    self.pending_friends.any?
  end

  def invite_friend(user)
    self.friend_request(user)
  end

  def not_friends
    potential_friends = []
    User.all.each do |user|
      if(self.friends_with?(user) != true && self != user && self.friends.include?(user) != true && self.pending_friends.include?(user) != true && self.requested_friends.include?(user) != true)
        potential_friends << user
      end
    end
    return potential_friends
  end

  private
    # Converts email to all lower-case.
    def downcase_email
      self.email = email.downcase
    end

    # Creates and assigns the activation token and digest.
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end