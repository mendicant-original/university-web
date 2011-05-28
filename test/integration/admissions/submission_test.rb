require 'test_helper'

module Admissions
  class SubmissionTest < ActionDispatch::IntegrationTest

    def fill_application_form(attachment_path)
      fill_in "Email",                 :with => "rmu-other@test.com"
      fill_in "Github name",           :with => "ruanrmu"
      fill_in "Real name",             :with => "Ray M. Unka"
      fill_in "Nickname",              :with => "RbMU"
      fill_in "Password",              :with => "seekret"
      fill_in "Password confirmation", :with => "seekret"

      if attachment_path
        attach_file "user_admissions_submission_attributes_attachment",
                    attachment_path
      end
    end

    story "As an applicant I want to apply" do
      setup do
        @course = Factory(:course, :class_size_limit => 99_999)
        ::CURRENT_COURSE = @course.id
      end

      scenario "view application page" do
        visit '/admissions'
        assert_current_path '/admissions'

        assert_content @course.class_size_limit.to_s
      end

      scenario "without entering any information" do
        visit '/admissions'

        click_button "Submit Application"

        assert_current_path '/admissions/submissions'

        assert_errors "Github account name"
      end

      scenario "without including the attachment" do
        visit '/admissions'

        fill_application_form(nil)

        click_button "Submit Application"

        assert_current_path '/admissions/submissions'

        assert_errors "attachment must be present"
      end

      scenario "including an invalid attachment" do
        visit '/admissions'

        fill_application_form(File.join(Rails.root, 'Gemfile'))

        click_button "Submit Application"

        assert_current_path '/admissions/submissions'

        assert_errors "attachment should be a zip file"
      end


      scenario "including all required information" do
        visit '/admissions'

        zip_file = Tempfile.new("application.zip")
        zip_file.write "Zip File!!!"
        zip_file.close

        fill_application_form(zip_file.path)

        click_button "Submit Application"

        submission = Admissions::Submission.order("created_at DESC").first

        assert_current_path thanks_admissions_submission_path(submission.id)

        assert_content "Thanks"

        uploaded_file = File.join(Rails.root, "admissions", "submissions",
                          "#{submission.id}.zip")

        assert File.exists?(uploaded_file), "Uploaded file is missing"

        submission.destroy
      end

      scenario "but can't because the course is full" do
        @course.update_attribute(:class_size_limit, 0)

        visit '/admissions'

        assert_content "Sorry"
      end
    end
  end
end
