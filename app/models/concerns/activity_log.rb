module ActivityLog
  def record_activity object, user_id, target_id, type_activity
    @activity = object.activities.create user_id: user_id, target_id: target_id, 
      type_activity: type_activity
  end
end
