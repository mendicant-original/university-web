ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'
require 'support/integration'
require 'support/mini_contest'
require 'test_notifier/runner/minitest'

TestNotifier.silence_no_notifier_warning = true

class ActionDispatch::IntegrationTest
  include Capybara
  include Support::Integration

  Capybara.javascript_driver = :webkit

  teardown do
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end
