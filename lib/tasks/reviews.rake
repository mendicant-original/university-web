namespace :reviews do 

  desc 'migrate all review data to submissions'
  task :migrate => :environment do
    Assignment::Activity.delete_all
    
    Assignment::Review.all.each do |review|
      submission = review.submission
      
      review.comments.each do |comment|
        comment.commentable = submission
        comment.save!
      end
    end
  end
  
  desc 'create activities for comments with no activites'
  task :generate_activities => :environment do
    Comment.where(:commentable_type => "Assignment::Submission").each do |c|
      a = Assignment::Activity.where(:actionable_type => "Comment",
                                     :actionable_id   => c.id)
      if a.empty?
        activity = a.create(
          :submission_id => c.commentable.id, 
          :user_id       => c.user.id,
          :description   => "made a comment",
          :context       => ActivityHelper.context_snippet(c.comment_text)
        )
        
        activity.update_attribute(:created_at, c.created_at)
      end
    end
  end
  
  desc 'create comments for review descriptions'
  task :generate_comments_for_descriptions => :environment do
    Assignment::Review.all.each do |review|
      submission = review.submission
      
      c = submission.comments.create(
        :user_id      => submission.user_id,
        :comment_text => review.description
      )
      
      c.update_attribute(:created_at, review.created_at)
    end
  end
end
