class Assignment
  class Submission < ActiveRecord::Base
    belongs_to :status,     :class_name  => "::SubmissionStatus",
                            :foreign_key => "submission_status_id"
    belongs_to :user
    belongs_to :assignment

    has_many   :comments,   :as        => :commentable,
                            :dependent => :delete_all

    has_many   :activities, :dependent => :delete_all

    validates :github_repository, :length => { :maximum => 25 }

    scope :all_active, includes(:assignment => :course).where(:courses => {:archived => false})

    scope :with_github_repository, all_active.where('github_repository IS NOT NULL')

    def associate_with_github(github_repo)

      stripped_repo = github_repo.split('/').last

      full_repo = "#{user.github_account_name}/#{stripped_repo}"

      update_attribute(:github_repository, full_repo)

      activities.create(
        user_id:       user.id,
        context:       "updated github repository",
        description:   "updated github repository to: #{full_repo}",
        actionable:    self
      )

    end

    def add_github_commit(commit)

      if(last_commit_time.nil? || commit.commit_time > last_commit_time)
        update_attributes(
            last_commit_time:  commit.commit_time,
            last_commit_id:    commit.id
        )
      end

      activities.create(
          user_id:       user.id,
          context:       "#{commit.id}-#{commit.message}",
          description:   "committed: #{commit.message}",
          created_at:    commit.commit_time,
          actionable:    self
      )

    end

    def create_review(review_type, comment)
      return if current_review

      review_class = case review_type
      when "feedback"
        Feedback
      when "evaluation"
        Evaluation
      else
        return
      end

      review = review_class.create(:comment => comment,
                                   :submission => self)

      activities.create(
        :user_id       => comment.user.id,
        :description   => "requested #{review_type}",
        :context       => ActivityHelper.context_snippet(comment.comment_text),
        :actionable    => comment
      )
    end

    def create_comment(comment_data)
      review_type = comment_data.delete(:type)

      comment = comments.build(comment_data)

      if comment.save

        review = create_review(review_type, comment)

        activities.create(
          :user_id       => comment.user.id,
          :description   => "made a comment",
          :context       => ActivityHelper.context_snippet(comment.comment_text),
          :actionable    => comment
        ) unless review

        UserMailer.submission_comment_created(comment).deliver

      end

      comment
    end

    def update_status(user, new_status)
      activity = activities.create(
        :user_id     => user.id,
        :description => "updated status",
        :context     => "Updated status from *#{self.status.name}* to " +
                        "*#{new_status.name}*",
        :actionable  => self
      )

      update_attribute(:submission_status_id, new_status.id)

      UserMailer.submission_updated(activity).deliver
    end

    def update_description(user, new_description)
      return unless new_description != self.description

      activity = activities.create(
        :user_id     => user.id,
        :description => "updated description",
        :actionable  => self
      )

      send_email = description.blank?

      update_attribute(:description, new_description)

      UserMailer.submission_updated(activity).deliver if send_email
    end

    def editable_by?(user)
      assignment.course.instructors.include?(user) or self.user == user
    end

    def current_review
      @current_review ||= Review.where(:submission_id => id).current
      @current_review
    end

    def last_active_on
      if activities.any?
        activities.last.created_at
      else
        updated_at
      end
    end
  end
end