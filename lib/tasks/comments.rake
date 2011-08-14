require 'csv'

namespace :comments do

  desc 're-index all comments'
  task :reindex => :environment do
    Assignment::Submission.find_each do |submission|
      submission.comments.order("created_at").each_with_index do |comment, index|
        comment.update_attributes(:index => index + 1)
      end
    end
  end


end
