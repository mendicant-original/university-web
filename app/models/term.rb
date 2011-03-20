class Term < ActiveRecord::Base
  has_many :courses
  has_many :exams

  has_many :waitlisted_students, :dependent => :destroy
  has_many :students,            :through   => :waitlisted_students

  validates_presence_of :name, :start_date, :end_date
  validate :end_date_must_be_greater_than_or_equal_to_start_date

  private

  def end_date_must_be_greater_than_or_equal_to_start_date
    if (start_date && end_date && end_date < start_date)
      errors.add(:end_date, "must be greater than or equal to the start date")
    end
  end
end
