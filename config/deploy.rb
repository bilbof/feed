require 'yaml'
# Expected to be called from the root of the project
secrets = YAML.load_file('config/secrets.yml')
user = secrets['capistrano_user']
ip_address = secrets['ip_address']
# config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"

set :application, "feed_app"
set :repository, '_site'
set :repo_url, "git@github.com:bilbof/feed.git"
set :deploy_via, :copy
set :copy_compression, :gzip
set :use_sudo, false
set :user, user
role :web, ip_address
set :app_env, "production"

set :deploy_to, "/var/apps/#{fetch(:application)}"

# https://github.com/javan/whenever#capistrano-integration
# TODO: set up whenever
set :whenever_command, "bundle exec whenever"

append :linked_dirs, '.bundle'

# before 'deploy:started', 'deploy:update_jekyll'

# TODO: set up app deploy script...
namespace :deploy do
  desc "Check that we can access everything"
  task :check_write_permissions do
    on roles(:all) do |host|
      if test("[ -w #{fetch(:deploy_to)} ]")
        info "#{fetch(:deploy_to)} is writable on #{host}"
      else
        error "#{fetch(:deploy_to)} is not writable on #{host}"
      end
    end
  end

  desc "Start the application"
  task :start_application do
    on roles(:app) do
      puts "Starting application"
      invoke "foreman:export"
      invoke "foreman:restart"
    end
  end

  desc "Stop the application"
  task :stop_application do
    on roles(:app) do
      invoke "foreman:stop"
    end
  end

  # [:restart, :finalize_update].each do |t|
  #   desc "#{t} task will start the application"
  #   task t do
  #     on roles(:app) do
  #       invoke "deploy:start_application"
  #     end
  #   end
  # end

  desc 'Run jekyll to update site before uploading'
  task :update_jekyll do
    puts "Building _site"
    # clear existing _site
    # build site using jekyll
    # remove Capistrano stuff from build
    %x(rm -rf _site/* && jekyll build && rm _site/Capfile && rm -rf _site/config && rm -rf _site/log)
  end
end

after "deploy:published", "deploy:start_application"

# ==========
#  Template
# ==========

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
