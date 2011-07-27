require "test_helper"

module Students
  class AccessPasswordChangeTest < ActionDispatch::IntegrationTest
    context "As a Student accessing the application for the first time" do
      setup do
        @user = Factory(:user, :requires_password_change => true)
        sign_user_in @user
      end

      test "require password change" do
        assert_current_path dashboard_path
        assert_title "Please enter a new password"

        fill_in "New Password", :with => "654321"
        fill_in "Password Confirmation", :with => "654321"
        click_button "Update User"

        assert_current_path new_user_session_path
        assert_content 'You need to sign in before continuing.'
        assert_no_content "IRC Channels"
      end

      test "attempt to use invalid password combination when required" do
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
