module ActivityHelper
  extend self
  
  def context_snippet(context, size=75)
    return context if context.length <= size

    context[0..size] + "..."
  end
  
  # Returns an array of [Activity, [Activity, ...]] grouped by consecutive 
  # Activity objects for description updates
  #
  def group_by_description(activities)
    grouped_activities = Array.new
    
    activities.each do |activity|
      if activity.description[/description/]
        if grouped_activities.last && 
           grouped_activities.last[0].description[/description/]
          
          grouped_activities.last[1] << activity
        else
          grouped_activities << [activity, Array.new]
        end
      else
        grouped_activities << [activity, Array.new]
      end
    end
    
    grouped_activities
  end
end
