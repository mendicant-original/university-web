require File.expand_path('../test_helper', __FILE__)

class AuthenticationTest < ActionController::IntegrationTest

  story 'As a user who has never been to the Uni-Web before' do

    scenario 'attempt to sign in with invalid credentials' do
      visit '/'
      fill_in 'user_email', :with => 'anybody@example.org'
      fill_in 'user_password', :with => 'a wrong password'
      click_button 'Sign in'
      assert_contain 'Invalid email or password.'
    end

    scenario 'sign up' do
      visit '/'
      fill_in 'user_email', :with => 'anybody@example.org'
      
    end
  end

end