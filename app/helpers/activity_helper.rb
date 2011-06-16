module ActivityHelper
  extend self
  
  def context_snippet(context, size=75)
    return context if context.length <= size

    context[0..size] + "..."
  end
  
  # Returns an array of [Activity, [Activity, ...]] grouped by consecutive 
  # Activity objects for description updates
  def group_by_description(activities)
    Assignment::ActivityGrouper.new(activities).group_by_description
  end

end
