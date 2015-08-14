class User < ActiveRecord::Base
  include ActivityLog

  before_save {email.downcase!}
  after_create :create_new_user_activity
  after_update :update_profile_activity

  has_many :activities
  has_many :lessons
  has_many :active_relationships, class_name: "Relationship",
    foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships, class_name:  "Relationship",
    foreign_key: "followed_id", dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  
  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  validates :password, presence: true, length:{minimum: 6},
    on: :update, allow_blank: true

  has_secure_password

  def follow other_user 
    active_relationships.create followed_id: other_user.id
  end

  def unfollow other_user
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following? other_user
    following.include? other_user
  end

  def activity_log
    following_ids = "SELECT followed_id FROM relationships
      WHERE  follower_id = :user_id"
    Activity.where("user_id IN (#{following_ids})
      OR user_id = :user_id", user_id: id)
  end

  private
  def create_new_user_activity
    record_activity self, self.id, nil, "create account"
  end
 
  def update_profile_activity
    record_activity self, self.id, nil, "update profile"
  end
end
