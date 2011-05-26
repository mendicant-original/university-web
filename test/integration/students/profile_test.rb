require 'test_helper'
require 'mocha'

module Students
  class ProfileTest < ActionDispatch::IntegrationTest

    story "As a Student who has a github acount
                i want to see my repositories listed" do

      setup do
        @user = sign_user_in
        # Stubbing external access
        @first_repo  = mock_repository(:name        => "repo1",
                                       :description => "foo bar project",
                                       :fork        => false,
                                       :watchers    => 37,
                                       :forks       => 17)

        @second_repo = mock_repository(:name => "repo2", :fork => true)

        Octokit.stubs("repos").with("rmu_student").returns([@first_repo, @second_repo])
      end
      scenario "viewing profile" do
        click_link_within  '#header', 'View Profile'

        assert_current_path user_path(@user)

        within("#github-repositories") do
          assert       page.has_content?  "repo1"
          assert       page.has_content?  "foo bar project"
          assert       page.has_content?  "watchers: 37"
          assert       page.has_content?  "forks: 17"

          assert_false page.has_content? "repo2"
        end
      end
    end

    story "As a Student i want to view my own profile information" do
      setup do
        @user = sign_user_in
      end

      scenario "view profile" do
        click_link_within '#header', 'View Profile'
      end
    end

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
        assert_content "rmu-other@test.com"
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
    private
    def mock_repository(params)
      opts = { :name => 'repo1' ,
               :fork => true,
               :watchers => 1,
               :forks => 1 ,
               :description => "repo1 description"}.merge(params)

      stub(opts)
    end
  end
end
