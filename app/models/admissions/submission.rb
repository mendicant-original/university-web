class Admissions::Submission < ActiveRecord::Base
  after_create   :save_attachment
  after_create   :notify_staff
  before_create  :set_status
  before_destroy :delete_attachment
  
  belongs_to :status, :class_name => "Admissions::Status"
  belongs_to :user
  belongs_to :course
  
  has_many   :comments,   :as        => :commentable,
                          :dependent => :delete_all
  
  def attachment=(tempfile)
    @tempfile = tempfile
  end
  
  def attachment
    File.join(attachment_dir, [self.id, 'zip'].join('.'))
  end
  
  def attachment_dir
    File.join(Rails.root, 'admissions', 'submissions')
  end
  
  def notify_staff
    UserMailer.application_created(self).deliver
  end
  
  private
  
  def set_status
    self.status_id ||= Admissions::Status.default.id
  end
  
  def save_attachment
    FileUtils.mkdir_p(attachment_dir)
    File.open(attachment, "wb") { |f| f.write(@tempfile.read) }
  end
  
  def delete_attachment
    FileUtils.rm(attachment)
  end
  
  def validate
    if new_record?
      if @tempfile.blank?
        errors.add("attachment", "must be present")
      elsif !File.basename(@tempfile.original_filename)[/.zip/]
        errors.add("attachment", "should be a zip file")
      end
    end
  end
end
