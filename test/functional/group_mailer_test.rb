require File.expand_path(File.join('test', 'test_helper'))

class GroupMailerTest < ActionMailer::TestCase
  setup do
    student_emails = "one@two.com, two@three.com, three@four.com"
    gm = GroupMail.new(:recipients => student_emails, :subject => "News",
                       :content => "Listen up!")
    @email = GroupMailer.mass_email(gm).deliver
  end

  test "sends group email" do
    assert !ActionMailer::Base.deliveries.empty?
  end

  test "sends email to rmu.management@gmail.com by default" do
    assert @email.to.include?("rmu.management@gmail.com")
    assert_equal 1, @email.to.length
  end

  test "sends group email to all specified students" do
    assert_equal 3, @email.bcc.length
    assert @email.bcc.include?("two@three.com")
  end

  test "sends the right email" do
    assert_equal "News", @email.subject
    assert_match /Listen up!/, @email.encoded
  end
end
