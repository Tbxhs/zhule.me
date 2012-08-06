require "bundler/capistrano"

# If you have custom Sidekiq configuration options put them in config/sidekiq.yml
# require "sidekiq/capistrano"

require "rvm/capistrano"
set :rvm_ruby_string, '1.9.2'
set :rvm_type, :user

set :application, "zhule"
set :repository,  "nick@192.168.0.103:www/#{application}"


set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :deploy_to, "/home/nick/www/#{application}"
set :branch, 'master'

server "192.168.0.103", :app, :web, :db, :primary => true
set :user, 'nick'
set :use_sudo, false

default_run_options[:pty] = true

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

task :mongoid_create_indexes, :roles => :web do
  run "cd #{deploy_to}/current/; RAILS_ENV=production bundle exec rake db:mongoid:create_indexes"
end

task :compile_assets, :roles => :web do
  run "cd #{deploy_to}/current/; RAILS_ENV=production bundle exec rake assets:precompile"
end

after 'deploy:update_code', :compile_assets