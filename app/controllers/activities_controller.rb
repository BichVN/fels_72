class ActivitiesController < ApplicationController
  def index
    @activities = current_user.activities.paginate page: params[:page],
      per_page: 30
  end
end
