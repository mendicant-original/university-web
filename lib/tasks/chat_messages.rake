namespace :chat_messages do
  desc "checks all chat messages for IRC 'ACTION' format, and formats them correctly"
  task :fix_action => :environment do
    Chat::Message.find_each do |message|
      message.check_action
      message.save if message.changed?
    end

    puts "Fixed all #{Chat::Message.count} messages."
  end
end
