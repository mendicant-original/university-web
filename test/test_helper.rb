ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'
require 'support/integration'
require 'support/mini_contest'
require 'test_notifier/runner/minitest'

class ActionDispatch::IntegrationTest
  include Capybara
  include Support::Integration

  teardown { Capybara.reset_sessions! }
end
