class Admissions::Submission < ActiveRecord::Base
  after_create   :save_attachment
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
    File.join(attachment_dir, self.id.to_s + '.zip')
  end
  
  def attachment_dir
    File.join(Rails.root, 'public', 'admissions', 'submissions')
  end
  
  private
  
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
        errors.add_to_base("Puzzlenode file is required!")
      elsif !File.basename(@tempfile.original_filename)[/.zip/]
        errors.add_to_base("Puzzlenode file should be a zip file!")
      end
    end
  end
end
