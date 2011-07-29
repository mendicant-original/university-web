source "http://rubygems.org"

########
# Core #
########

gem "rails",  "3.0.7"
gem "devise", "1.3.4"
gem "rake",   "0.8.7"
gem "rack",   "~> 1.2.1"

########
# Data #
########

gem "pg"
gem "json"
gem "sanitize", "~> 2.0.0"
gem "octokit"
gem "texticle", "2.0", :require => "texticle/rails"

################
# Presentation #
################

gem "compass",       "~> 0.10.4"
gem "haml"
gem "sass"
gem "rdiscount"
gem "will_paginate", "~> 3.0.pre2"


group :test do
  gem "minitest",  "~> 2.3.1"
  gem "capybara",  "~> 0.4.1.1"
  gem "factory_girl_rails"
  gem "mocha"
  gem "colorific", "~> 1.0.0"

  # Use jordanbyron"s unofficial fork of test_notifier until the support for
  # MiniTest gets merged
  #
  gem "test_notifier", :git =>
    "git://github.com/jordanbyron/test_notifier.git", :branch => "minitest-test"
end

group :production do
  gem "whenever", "~> 0.6.8", :require => false
end
