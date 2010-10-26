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
end
