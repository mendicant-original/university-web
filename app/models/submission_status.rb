class SubmissionStatus < ActiveRecord::Base

  def self.default
    order("sort_order").first
  end

end
