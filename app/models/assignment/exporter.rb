class Assignment::Exporter
  def initialize(assignment)
    @assignment = assignment
  end

  # returns a hash of the assignment that can be serialized
  def export
    export_assignment(@assignment)
  end

  # returns a string containing the export serialized to yaml
  def to_yaml
    export.to_yaml
  end

  # returns a string containing the gzipped yaml
  def to_gzip
    ActiveSupport::Gzip.compress to_yaml
  end

  # returns a tempfile containing the gzipped export
  def to_file
    file = Tempfile.new('assignment-exporter')
    file << to_gzip
    file.rewind
    file
  end

  def to_s
    "<Assignment::Exporter assignment=#{@assignment.id}>"
  end

  private
  def export_assignment(assignment)
    data = {
      :name        => assignment.name,
      :description => assignment.description
    }

    submissions = assignment.submissions.includes(:comments   => :user,
                                                  :activities => :user)

    data[:submissions] = submissions.map { |s| export_submission(s) }

    data
  end

  def export_submission(submission)
    data = {
      :description => submission.description,
      :status      => submission.status.try(:name)
    }

    data[:comments]   = submission.comments.map   { |c| export_comment c }
    data[:activities] = submission.activities.map { |a| export_activity a }
    data
  end

  def export_comment(comment)
    {
      :updated_at   => comment.updated_at,
      :user         => comment.user.name,
      :comment_text => comment.comment_text
    }
  end

  def export_activity(activity)
    {
      :updated_at  => activity.updated_at,
      :user        => activity.user.name,
      :description => activity.description
    }
  end
end
