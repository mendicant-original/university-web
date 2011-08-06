require "test_helper"

class GithubHelperTest < ActiveSupport::TestCase
  context "reading the config file" do

    test "should fail if the github config file is not present" do
      assert_raises(RuntimeError) do
        Github::GithubHelper.config("doesnt_exist")
      end
    end

    test "should read the token from the config" do
      config = Github::GithubHelper.config("github.yml.example")
      assert_equal "username_goes_here",  config["username"]
      assert_equal "api_token_goes_here", config["api_token"]
    end

  end
end
