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
      a = Assignment::Activity.where(:actionable => c)
      unless a
        a.create(
          :submission_id => c.commentable.id, 
          :user_id       => c.user.id,
          :description   => "made a comment",
          :context       => ActivityHelper.context_snippet(c.comment_text)
        )
        
        a.update_attribute(:created_at, c.created_at)
      end
    end
  end
end
