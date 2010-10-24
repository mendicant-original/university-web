require File.expand_path('../../test_helper', __FILE__)

require 'stories'
require 'webrat'

Webrat.configure do |config|
  config.mode = :rack
end
