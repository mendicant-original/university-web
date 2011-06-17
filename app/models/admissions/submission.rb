module Admissions
  class Submission < ActiveRecord::Base
    after_create   :save_attachment
    after_create   :notify_staff

    after_update   :send_reviewer_notice
    after_update   :send_received_notice
    before_create  :set_status
    before_destroy :delete_attachment

    belongs_to :status, :class_name => "Admissions::Status"
    belongs_to :user
    belongs_to :course

    has_many   :comments,   :as        => :commentable,
                            :dependent => :delete_all

    scope :reviewable, includes(:status).
      where(["admissions_statuses.reviewable = ?", true])

    validate :attachment_valid

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
      AdmissionsMailer.application_created(self).deliver

      return true
    end

    def create_comment(comment_data)
      comment = comments.create(comment_data)

      if comment.errors.empty?
        AdmissionsMailer.application_comment_created(comment).deliver
      end
    end

    private

    def set_status
      self.status_id ||= Admissions::Status.default.id

      return true
    end

    def save_attachment
      FileUtils.mkdir_p(attachment_dir)
      File.open(attachment, "wb") { |f| f.write(@tempfile.read) }

      return true
    end

    def delete_attachment
      FileUtils.rm(attachment) if File.exists?(attachment)

      return true
    end

    def attachment_valid
      if new_record?
        if @tempfile.blank?
          errors.add("attachment", "must be present")
        elsif !File.basename(@tempfile.original_filename)[/.zip/]
          errors.add("attachment", "should be a zip file")
        end
      end
    end

    def send_reviewer_notice
      if self.status_id_changed?
        old_status = Admissions::Status.find_by_id(self.status_id_was)

        if old_status && old_status.reviewable != true && self.status.reviewable
          AdmissionsMailer.application_reviewable(self).deliver
        end
      end
    end

    def send_received_notice
      if self.status_id_changed? && status == Admissions::Status.received
        AdmissionsMailer.application_received(self).deliver
      end
    end
  end
end
