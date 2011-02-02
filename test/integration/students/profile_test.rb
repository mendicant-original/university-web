require 'test_helper'

module Students
  class ProfileTest < ActionDispatch::IntegrationTest
    story "As a Student I want to change my profile information" do
      setup do
        @user = sign_user_in
      end

      scenario "edit profile" do
        click_link_within '#header', 'Edit Profile'

        assert_current_path edit_user_path(@user)
        assert_field "Email",     :with => @user.email
        assert_field "Real name", :with => @user.real_name

        fill_in "Email",     :with => "rmu-other@test.com"
        fill_in "Github",    :with => "ruanrmu"
        fill_in "Twitter",   :with => "rmuruan"
        select  "(GMT-03:00) Brasilia", :from => "Time zone"
        click_button "Update"

        assert_current_path user_path(@user)
        assert_flash "Profile sucessfully updated"
        assert_content "Email: rmu-other@test.com"
        assert_content "Github: ruanrmu"
        assert_content "Twitter: rmuruan"
        assert_no_content "Brasilia"
      end

      scenario "attempt to edit profile with invalid info" do
        click_link_within '#header', 'Edit Profile'

        fill_in "Email",     :with => "rmu-invalid@test"
        fill_in "Twitter",   :with => "rmu-ruan"
        click_button "Update"

        assert_current_path user_path(@user)
        assert_errors "Email is invalid",
          "Twitter account name can only contain letters, numbers or underscores"
      end
    end
  end
end
