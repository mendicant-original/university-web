require 'bundler/capistrano'

set :application, "university-web"
set :repository,  "git://github.com/mendicant-university/university-web.git"

set :scm, :git
set :deploy_to, "/var/rapp/#{application}"

set :user, "git"
set :use_sudo, false

set :deploy_via, :remote_cache

set :branch, "remove-public-site"
server "school.mendicantuniversity.org", :app, :web, :db, :primary => true

namespace :deploy do
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

after 'deploy:update_code' do
  {"config/database.yml"    => "config/database.yml",
   "config/secret_token.rb" => "config/initializers/secret_token.rb",
   "config/setup_mail.rb"   => "config/initializers/setup_mail.rb",
   "config/api_access.rb"   => "config/initializers/api_access.rb",
   "admissions"             => "admissions",
   "config/github.yml"      => "config/github.yml"}.
  each do |from, to|
    run "ln -nfs #{shared_path}/#{from} #{release_path}/#{to}"
  end
end

after "deploy", "deploy:migrate"
after "deploy", 'deploy:cleanup'