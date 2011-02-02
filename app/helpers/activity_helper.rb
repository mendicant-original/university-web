module ActivityHelper
  extend self

  def context_snippet(context, size=75)
    return context if context.length <= size

    context[0..size] + "..."
  end
end
