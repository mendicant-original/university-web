require 'test_helper'

module Admissions
  class SubmissionTest < ActionDispatch::IntegrationTest

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

      scenario "apply without entering any information" do
        visit '/admissions'

        click_button "Submit Application"

        assert_path submissions_admissions_path

        assert_errors "github_account_name"
      end
    end
  end
end
