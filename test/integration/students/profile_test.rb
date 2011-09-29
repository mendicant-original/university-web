require 'test_helper'

module Students
  class ProfileTest < ActionDispatch::IntegrationTest

    context "As a Student who has a github acount
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

      test "viewing profile" do
        click_link_within  '#header', 'View Profile'

        assert_current_path user_path(@user)

        within("#github-repositories") do
          assert         page.has_content? "repo1"
          assert         page.has_content? "foo bar project"
          assert_image   "icons/github/watcher.png"
          assert         page.has_content? "37"
          assert_image   "icons/github/fork.png"
          assert         page.has_content? "17"
          assert         page.has_content? "Ruby"

          refute         page.has_content? "repo2"
        end
      end

      test "viewing a profile that don't have any repositories associated" do
        Octokit.stubs("repos").raises("404 Error")

        click_link_within  '#header', 'View Profile'

        assert_current_path user_path(@user)
        refute page.has_content? "#github-repositories"
      end
    end

    context "As a Student i want to view my own profile information" do
      setup do
        @user = sign_user_in
      end

      test "view profile" do
        click_link_within '#header', 'View Profile'
      end
    end

    context "As a Student I want to change my profile information" do
      setup do
        @user = sign_user_in
      end

      test "edit profile" do
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

        assert_content 'rmu-other@test.com'
        assert_content "Github: ruanrmu"
        assert_content "Twitter: rmuruan"
        assert_no_content "Brasilia"
      end

      test "attempt to edit profile with invalid info" do
        click_link_within '#header', 'Edit Profile'

        fill_in "Email",     :with => "rmu-invalid@test"
        fill_in "Twitter",   :with => "rmu-ruan"
        click_button "Update"

        assert_current_path user_path(@user)
        assert_errors "Email is invalid",
          "Twitter account name can only contain letters, numbers or underscores"
      end

      test "attempt to hide an irc channel" do
        @chat_channel = Factory(:chat_channel)
        @user.chat_channels << @chat_channel

        click_link_within '#header', 'Edit Profile'

        assert_content @chat_channel.name
        uncheck @chat_channel.name
        click_button "Update"

        refute @user.chat_channel_memberships.where(:channel_id => @chat_channel).first.visible_on_dashboard
      end
    end

    private

    def mock_repository(params)
      opts = {
        :name => 'repo1' ,
        :fork => true,
        :watchers => 1,
        :forks => 1 ,
        :language => "Ruby",
        :url => "http://github.com/rmu_student/repo1",
        :description => "repo1 description"
      }.merge(params)

      mock = Mocha::Mock.new("Repo")
      mock.stubs(opts)
      mock
    end
  end
end
