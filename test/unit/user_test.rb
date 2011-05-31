require "test_helper"
require 'mocha'

class UserTest < ActiveSupport::TestCase
  setup do
    @attrs = {
      :email => "one@example.com",
      :password => "secret",
      :real_name => "Tom Ward",
      :nickname => "nick",
      :twitter_account_name => "kwiz7",
      :github_account_name => "amaze-1"
    }
  end

  test "should save user with valid attributes" do
    user = User.new(@attrs)
    assert user.valid?
    assert user.save
  end

  test "should require a real name or nickname" do
    no_name_user = User.new(@attrs.merge(:real_name => "", :nickname => ""))
    assert !no_name_user.valid?
    assert no_name_user.errors[:base].include?(
      "You need to provide either a real name or a nick name")
  end

  test "should allow nickname without a real name" do
    user = User.new(@attrs.merge(:nickname => ""))
    assert user.valid?
  end

  test "should not allow github username with invalid format" do
    user = User.new(@attrs.merge(:github_account_name => "-amaze-1"))
    assert !user.valid?
    assert_not_nil user.errors[:github_account_name]
  end

  test "should not allow twitter username with invalid format" do
    user = User.new(@attrs.merge(:twitter_account_name => "kwiz-7"))
    assert !user.valid?
    assert_not_nil user.errors[:twitter_account_name]
  end

  test "should not allow github username that is too long" do
    long_github_name = "a" * 41
    user = User.new(@attrs.merge(:github_account_name => long_github_name))
    assert !user.valid?
    assert user.errors[:github_account_name].include?(
      "is too long (maximum is 40 characters)")
  end

  test "should not allow twitter username that is too long" do
    long_twitter_name = "a" * 16
    user = User.new(@attrs.merge(:twitter_account_name => long_twitter_name))
    assert !user.valid?
    assert user.errors[:twitter_account_name].include?(
      "is too long (maximum is 15 characters)")
  end

  test "should allow blank twitter username" do
    user = User.new(@attrs.merge(:twitter_account_name => ""))
    assert user.valid?
    assert user.save
  end

  test "should not allow blank github username" do
    user = User.new(@attrs.merge(:github_account_name => ""))
    assert !user.valid?
    assert !user.save
  end

  context ".search" do
    test "finds users by email" do
      user1 = Factory(:user, :email => "foo@test.com")
      user2 = Factory(:user, :email => "bar@test.com")

      results = User.search("foo", 1)
      assert_equal [user1], results
    end

    %w(real_name nickname twitter_account_name github_account_name).each do |attribute|
      test "find users by #{attribute}" do
        user1 = Factory(:user, attribute => "foo")
        user2 = Factory(:user, attribute => "bar")

        results = User.search("foo", 1)
        assert_equal [user1], results
      end
    end

    test "finds only users by a given course" do
      course1 = Factory(:course, :name => "Course 1")
      course2 = Factory(:course, :name => "Course 2")
      course1.users << (user1 = Factory(:user, :nickname => "foo"))
      course2.users << (user2 = Factory(:user, :nickname => "foo"))

      results = User.search("foo", 1, :course_id => course1.id)
      assert_equal [user1], results
    end

    test "sorts by email as default" do
      user1 = Factory(:user, :email => "foo2@test.com")
      user2 = Factory(:user, :email => "foo1@test.com")

      results = User.search("foo", 1)
      assert_equal [user2, user1], results
    end

    test "sorts by the given sort option" do
      user1 = Factory(:user, :nickname => "foo2")
      user2 = Factory(:user, :nickname => "foo1")

      results = User.search("foo", 1, :sort => :nickname)
      assert_equal [user2, user1], results
    end

    test "paginate results based on the given current page" do
      user1 = Factory(:user, :email => "foo1@test.com")
      user2 = Factory(:user, :email => "foo2@test.com")

      results = User.search("foo", 2, :per_page => 1)
      assert_equal [user2], results
    end
  end

  context "#name" do
    test "returns nickname if available" do
      user = User.new(@attrs)
      assert_equal @attrs[:nickname], user.name
    end

    test "returns real name if nickname is not available" do
      user = User.new(@attrs.merge(:nickname => ""))
      assert_equal @attrs[:real_name], user.name
    end

    test "returns email id if both nickname and real name are not available" do
      user = User.new(@attrs.merge(:nickname => "", :real_name => ""))
      assert_equal "one", user.name
    end
  end

  context "#access_level" do
    setup do
      @user = User.new
    end

    test "returns access level definitions based on current user access" do
      swap_access_level_definitions AccessLevel::User do |klass|
        klass.define "guest", :permissions => []
        klass.define "student", :permissions => [:do_whatever]

        @user.access_level = "guest"
        assert !@user.access_level.allows?(:do_whatever)

        @user.access_level = "student"
        assert @user.access_level.allows?(:do_whatever)
      end
    end
  end

  context "alumnus dates" do
    setup do
      @alumnus1 = Factory(:user,
                          :alumni_number => 1,
                          :alumni_year => 2010,
                          :alumni_month => 1)

      @alumnus2 = Factory(:user,
                          :alumni_number => 2,
                          :alumni_year => 2010,
                          :alumni_month => 2)

      @alumnus3 = Factory(:user,
                          :alumni_number => 3,
                          :alumni_year => 2010,
                          :alumni_month => 4)

      @alumnus4 = Factory(:user,
                          :alumni_number => 4,
                          :alumni_year => 2011,
                          :alumni_month => 12)

      @student  = Factory(:user)
    end

    test "has alumni scope that returns all alumni" do
      assert User.alumni.include?(@alumnus1)
      assert User.alumni.include?(@alumnus2)
      assert User.alumni.include?(@alumnus3)
      assert User.alumni.include?(@alumnus4)

      assert !User.alumni.include?(@student)
    end

    test "has per_year scope" do
      assert User.per_year(2010).include?(@alumnus1)
      assert User.per_year(2010).include?(@alumnus2)
      assert User.per_year(2010).include?(@alumnus3)

      assert !User.per_year(2010).include?(@alumnus4)
      assert User.per_year(2011).include?(@alumnus4)
    end

    test "should get alumni_date from year and month" do
      assert_equal @alumnus1.alumni_date, "2010-1-1".to_date
      assert_equal @alumnus2.alumni_date, "2010-2-1".to_date
      assert_equal @alumnus3.alumni_date, "2010-4-1".to_date
      assert_equal @alumnus4.alumni_date, "2011-12-1".to_date
    end
  end
  context "retrieving user github repositories" do
    setup do
      @first_repo  = stub(:name => "repo1", :fork => false, :pushed_at => Date.yesterday)
      @second_repo = stub(:name => "repo2", :fork => true , :pushed_at => Date.yesterday)
      @third_repo  = stub(:name => "repo3", :fork => false , :pushed_at => Date.today)
      @repos       = [ @first_repo, @second_repo, @third_repo]
      @user        = Factory.create(:user , :github_account_name => "pellegrino")
    end

    test "fetching user's repositories" do
      Octokit.stubs("repos").with("pellegrino").returns(@repos)
      retrieved_repositories = @user.github_repositories
      assert_equal  2 , retrieved_repositories.size
      assert_equal [ @third_repo, @first_repo ] , @user.github_repositories
    end

    test "returns a single element" do
      Octokit.stubs("repos").with("pellegrino").returns [@first_repo]
      assert_equal [ @first_repo ] , @user.github_repositories
    end

    test "non existing github account" do
      Octokit.stubs("repos").with("pellegrino").raises("404: Not Found")
      assert_equal [] ,  @user.github_repositories
    end

  end
  context "retrieving user locations" do
    setup do
      @expected = [[12.3456, 78.9012], [34.5678, 90.1234]]

      @expected.each do |loc|
        Factory.create(:user, :latitude => loc[0], :longitude => loc[1])
      end
    end

    test "retrieve all user locations" do
      assert_equal @expected, User.locations
    end

    test "retrieve locations only with a latitude & longitude" do
      Factory.create(:user)
      assert_equal @expected, User.locations
    end
  end


  private

  def swap_access_level_definitions(klass)
    begin
      current_definitions = klass.definitions.dup
      klass.definitions.clear

      yield klass
    ensure
      klass.definitions.clear
      klass.definitions.merge!(current_definitions)
    end
  end
end
