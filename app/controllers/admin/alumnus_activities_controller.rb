class Admin::AlumnusActivitiesController < Admin::Base

  def update
    activity = AlumnusActivity.find(params[:id])

    activity.update_attribute(:status, params[:value])

    render :text => params[:value]
  end

  def statuses
    statuses = Hash[AlumnusActivity.statuses.map {|s| [s, s] }]

    respond_to do |format|
      format.json { render :json => statuses.to_json }
    end
  end

end
