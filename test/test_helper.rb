ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'
require 'support/integration'
require 'support/mini_contest'
require 'test_notifier/runner/minitest'

TestNotifier.silence_no_notifier_warning = true

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  include Support::Integration

  teardown { Capybara.reset_sessions! }
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