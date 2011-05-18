class SubmissionStatus < ActiveRecord::Base

  def self.default
    default = order("sort_order").first
    default ||= SubmissionStatus.create(
      :name => "Pending Review", :sort_order => 0, :hex_color => "BD2B37")
      
    default
  end

end
