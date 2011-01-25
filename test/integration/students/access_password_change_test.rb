require "test_helper"

module Students
  class AccessPasswordChangeTest < ActionDispatch::IntegrationTest
    story "As a Student accessing the application for the first time" do
      setup do
        @user = Factory(:user, :nickname => "Ruan RMU",
                        :requires_password_change => true)
        sign_user_in @user
      end

      scenario "require password change" do
        assert_current_path dashboard_path
        assert_title "Please enter a new password"

        fill_in "New Password", :with => "654321"
        fill_in "Password Confirmation", :with => "654321"
        click_button "Update User"

        assert_current_path dashboard_path
        assert_no_field "New Password"
        assert_title "Ruan RMU"
      end

      scenario "attempt to use invalid password combination when required" do
        fill_in "New Password", :with => "654321"
        fill_in "Password Confirmation", :with => "123456"
        click_button "Update User"

        assert_current_path change_password_user_path(@user)
        assert_flash "Password doesn't match confirmation"

        fill_in "New Password", :with => "123"
        click_button "Update User"

        assert_current_path change_password_user_path(@user)
        assert_flash "Password is too short (minimum is 6 characters)"
      end
    end
  end
end
