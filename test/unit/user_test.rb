require File.expand_path(File.join('test', 'test_helper'))

class UserTest < ActiveSupport::TestCase

  setup do
    @attrs = {:email => "one@example.com", :password => "secret", 
    :real_name => "Tom Ward", :nickname => "nick", :twitter_account_name => "kwiz7", 
    :github_account_name => "amaze-1"}
  end
  
  test "should save user with valid attributes" do
    user = User.new(@attrs)
    assert user.valid?
    assert user.save
  end
  
  test "should require a real name or nickname" do
    no_name_user = User.new(@attrs.merge({:real_name => "", :nickname => ""}))
    assert !no_name_user.valid?
    assert no_name_user.errors[:base].include?("You need to provide either a real name or a nick name")
  end
  
  test "should allow nickname without a real name" do
    user = User.new(@attrs.merge({:nickname => ""}))
    assert user.valid?  
  end
  
  test "should not allow github username with invalid format" do
    user = User.new(@attrs.merge({:github_account_name => "-amaze-1"}))
    assert !user.valid?
    assert_not_nil user.errors[:github_account_name]
  end
  
  test "should not allow twitter username with invalid format" do
    user = User.new(@attrs.merge({:twitter_account_name => "kwiz-7"}))
    assert !user.valid?
    assert_not_nil user.errors[:twitter_account_name]
  end
  
  test "should not allow github username that is too long" do
    long_github_name = "a" * 41
    user = User.new(@attrs.merge({:github_account_name => long_github_name}))
    assert !user.valid?
    assert user.errors[:github_account_name].include?("is too long (maximum is 40 characters)")
  end
  
  test "should not allow twitter username that is too long" do
    long_github_name = "a" * 16
    user = User.new(@attrs.merge({:twitter_account_name => long_github_name}))
    assert !user.valid?
    assert user.errors[:twitter_account_name].include?("is too long (maximum is 15 characters)")
  end
  
  test "should allow blank twitter and github usernames" do
    user = User.new(@attrs.merge({:twitter_account_name => "", :github_account_name => ""}))
    assert user.valid?
    assert user.save
  end  
end
