ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'
require 'database_cleaner'
require 'support/integration'
require 'support/mini_contest'
require 'test_notifier/runner/minitest'

TestNotifier.silence_no_notifier_warning = true
DatabaseCleaner.strategy                 = :truncation

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  include Support::Integration

  # Stop ActiveRecord from wrapping tests in transactions
  self.use_transactional_fixtures = false

  Capybara.javascript_driver = :webkit

  teardown do
    DatabaseCleaner.clean
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end

# Temporary fix for rack related warning:
# https://github.com/jnicklas/capybara/issues/87
#
module Rack
  module Utils
    def escape(s)
      CGI.escape(s.to_s)
    end
    def unescape(s)
      CGI.unescape(s)
    end
  end
end
