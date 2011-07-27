ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'
require 'support/integration'

class ActiveSupport::TestCase
  # fixtures :all
end

class ActionDispatch::IntegrationTest
  include Capybara
  include Support::Integration

  teardown { Capybara.reset_sessions! }
end
