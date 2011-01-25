module Support
  module Integration
    def assert_css(css, options)
      assert has_css?(css, options),
        "CSS #{css.inspect} with options #{options.inspect} does not exist"
    end

    def assert_current_path(expected_path)
      assert_equal expected_path, current_path
    end

    def assert_flash(message)
      assert has_css?('#flash', :text => message),
        "Flash #{message.inspect} does not exist in the page"
    end

    def assert_no_flash
      assert has_no_css?('#flash'), "Flash exists in the page"
    end

    def assert_link(text)
      assert has_link?(text), "Link #{text} does not exist in the page"
    end

    def assert_no_link(text)
      assert has_no_link?(text), "Link #{text} exists in the page"
    end

    def assert_link_to(url, options)
      assert_css "a[href='%s']" % url, options
    end

    def assert_content(content)
      assert has_content?(content), "Content #{content.inspect} does not exist"
    end

    def assert_no_content(content)
      assert has_no_content?(content), "Content #{content.inspect} exist"
    end

    def sign_user_in(user=Factory(:user, :email => "rmu@test.com"))
      visit new_user_session_path

      fill_in 'Email',    :with => user.email
      fill_in 'Password', :with => user.password
      click_button 'Sign in'

      user
    end

    def sign_out
      click_link 'Sign Out'
    end

    def within(scope, prefix=nil)
      scope = '#' << ActionController::RecordIdentifier.dom_id(scope, prefix) if scope.is_a?(ActiveRecord::Base)
      super(scope)
    end
  end
end
