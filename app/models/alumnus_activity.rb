class AlumnusActivity < ActiveRecord::Base
  belongs_to :user
  belongs_to :term

  def self.statuses
    ["Not Started", "Accepted"]
  end
end
