class GroupMail
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :recipients, :subject, :content, :group_type, :group_id, :reply_to

  validates_presence_of :recipients, :content, :subject

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end

  def self.identify_group(group_type)
    case group_type
      when "All"
        ""
      when "Course"
        Course.all.map do |course|
          { :caption => course.full_name, :value => course.id }
        end.unshift({:caption => "Pick a course", :value => ""})
      when "Term"
        Term.all.map do |term|
          { :caption => term.name, :value => term.id }
        end.unshift({:caption => "Pick a term", :value => ""})
    end
  end

  def self.find_group_emails(group_type, group_id)
    case group_type
      when "All"
        User.select("email").where(:access_level => "student").
        map {|student| student.email }.join(", ")
      when "Course"
        course = Course.find group_id
        course.users.map {|student| student.email }.join(", ")
      when "Term"
        term = Term.find group_id

        student_emails = []
        # students who took a course in this term
        term.courses.each do |course|
        	student_emails <<	course.users.
        	                  map { |student| student.email }
        end

        # only unique emails
        student_emails.flatten.uniq.join(", ")
    end
  end

end
