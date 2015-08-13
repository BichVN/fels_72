class Relationship < ActiveRecord::Base
  include ActivityLog

  after_create :create_new_relationship_activity
  after_destroy :create_destroy_relationship_activity

  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  
  validates :follower_id, presence: true
  validates :followed_id, presence: true

  private
  def create_new_relationship_activity
    record_activity self.follower, self.follower.id, self.followed.id, "follow"
  end

  def create_destroy_relationship_activity
    record_activity self.follower, self.follower.id, self.followed.id, "unfollow"
  end
end
