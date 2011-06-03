module Admissions
  extend self

  def table_name_prefix
    'admissions_'
  end

  def reset!
    User.where(:access_level => "applicant").destroy_all +
    Admissions::Submission.destroy_all
  end
end
