source "http://rubygems.org"

########
# Core #
########

gem "rails",  "~> 3.0.7"
gem "devise", "~> 1.4.2"
gem "rack",   "~> 1.2.1"

########
# Data #
########

gem "pg"
gem "json"
gem "sanitize", "~> 2.0.0"
gem "octokit"
# Using jordanbyron's fork until his pull request is merged
gem "texticle", :git => "git://github.com/jordanbyron/texticle.git",
  :require => "texticle/rails"

################
# Presentation #
################

gem "compass",       "~> 0.10.4"
gem "haml", "~> 3.1"
gem "sass"
gem "rdiscount"
gem "will_paginate", "~> 3.0"
gem "cocoon"


group :test do
  gem "minitest",  "~> 2.3.1"
  gem "capybara",  "~> 0.4.1.1"
  gem "factory_girl_rails"
  gem "mocha"
  gem "colorific", "~> 1.0.0"
  gem "test_notifier", '~> 0.4.0'
end

group :production do
  gem "whenever", "~> 0.6.8", :require => false
end
