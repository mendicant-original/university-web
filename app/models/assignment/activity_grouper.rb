class Assignment::ActivityGrouper

  GROUPABLE_METHODS = [
      :is_a_description_update?,
      :is_a_github_commit?
  ]

  def initialize(activities)
    @activities = activities
  end

  def group_by_description
    @grouped_activities = []

    @activities.each do |activity|
      group(activity)
    end

    @grouped_activities
  end

  private

  def group(activity)
    if is_groupable?(activity)
      add_to_current_group(activity)
    else
      create_new_group(activity)
    end
  end

  def is_groupable?(activity)
    GROUPABLE_METHODS.any? do |method|
      activity.send(method) && current_group && current_group[0].send(method)
    end
  end

  def create_new_group(activity)
    @grouped_activities << [activity, Array.new]
  end

  def add_to_current_group(activity)
    current_group[1] << activity
  end

  def current_group
    @grouped_activities.last
  end

end