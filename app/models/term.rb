class Term < ActiveRecord::Base
  has_many :courses
  has_many :exams

  has_many :waitlisted_students, :dependent => :destroy
  has_many :students,            :through   => :waitlisted_students

  validates_presence_of :name, :start_date, :end_date
  validate :end_date_must_be_greater_than_or_equal_to_start_date

  scope :per_year, lambda {|year|
                            where(["start_date BETWEEN ? AND ?",
                            "#{year}/1/1".to_date, "#{year}/12/31".to_date])}

  # Returns all alumni users (the ones having an alumni_number)
  # whose alumni_year and alumni_month falls between this term's
  # start and end dates
  def alumni
    User.alumni.select {|u| (start_date..end_date).include?(u.alumni_date) }
  end

  private

  def end_date_must_be_greater_than_or_equal_to_start_date
    if (start_date && end_date && end_date < start_date)
      errors.add(:end_date, "must be greater than or equal to the start date")
    end
  end
end
