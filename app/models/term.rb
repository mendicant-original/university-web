class Term < ActiveRecord::Base
  has_many :courses
  has_many :alumnus_activities, :dependent => :destroy

  validates_presence_of :start_date, :end_date, :year, :number
  validate :end_date_must_be_greater_than_or_equal_to_start_date

  # Returns all alumni users (the ones having an alumni_number)
  # whose alumni_year and alumni_month falls between this term's
  # start and end dates
  def alumni
    User.alumni.select {|u| (start_date..end_date).include?(u.alumni_date) }
  end

  def name
    if year.blank? and number.blank?
      read_attribute(:name)
    else
      [year, "T#{number}"].join("/")
    end
  end

  def activity_for(user)
    alumnus_activities.find_or_create_by_user_id(user.id)
  end

  private

  def end_date_must_be_greater_than_or_equal_to_start_date
    if (start_date && end_date && end_date < start_date)
      errors.add(:end_date, "must be greater than or equal to the start date")
    end
  end

end
