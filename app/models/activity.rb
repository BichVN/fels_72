class Activity < ActiveRecord::Base
  include ActivityLog

  belongs_to :user

  scope :activity_log, ->(follower_ids, user_id){where("user_id IN(?) OR user_id =?", follower_ids, user_id)}
end
