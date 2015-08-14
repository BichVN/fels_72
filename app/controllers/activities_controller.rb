class ActivitiesController < ApplicationController
  def index
    @activities = Activity.activity_log current_user.follower_ids, current_user.id
  end
end
