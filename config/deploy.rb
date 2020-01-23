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

set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, File.read('.ruby-version').strip
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value

append :linked_dirs, '.bundle'

# Default settings
set :foreman_use_sudo, false # Set to :rbenv for rbenv sudo, :rvm for rvmsudo or true for normal sudo
set :foreman_roles, :app
set :foreman_init_system, 'systemd'
# set :foreman_export_path, ->{ File.join(Dir.home, '.init') }
set :foreman_app, -> { "#{fetch(:application)}" }
set :foreman_app_name_systemd, -> { "#{ fetch(:foreman_app) }.target" }
# set :foreman_options, ->{ {
#   app: fetch(:foreman_app),
#   log: File.join(shared_path, 'log')
# } }
set :foreman_log, -> { File.join(shared_path, 'log') }
set :foreman_port, 3000

set :deploy_to, "/var/apps/#{fetch(:application)}"
set :foreman_export_path, "/home/#{user}/.config/systemd/user"

# https://github.com/javan/whenever#capistrano-integration
# TODO: set up whenever
set :whenever_command, "bundle exec whenever"

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

  task :export_systemctl do
    on roles(:app) do
      puts "Exporting foreman procfile to systemctl"
      execute "cd #{fetch(:deploy_to)}/current && #{fetch(:rbenv_prefix)} foreman export systemd #{fetch(:foreman_export_path)} -a #{fetch(:foreman_app)} -l #{fetch(:foreman_log)} -p #{fetch(:foreman_port)} -u deploy"
      execute "sudo systemctl enable /home/deploy/.config/systemd/user/feed_app.target"
      execute "sudo systemctl daemon-reload"
    end
  end

  task :start do
    on roles(:app) do
      puts "Starting application"
      invoke "deploy:export_systemctl"
      execute "sudo systemctl start #{fetch(:foreman_app)}.target" # 2>/dev/null
    end
  end

  desc "Restart the procfile worker"
  task :restart do
    on roles(:app) do
      puts "Restarting application"
      invoke "deploy:export_systemctl"
      execute "sudo systemctl reload-or-restart #{fetch(:foreman_app)}.target"
    end
  end

  desc "Stop the application"
  task :stop_application do
    on roles(:app) do
      execute "sudo systemctl stop #{fetch(:foreman_app)}.target"
    end
  end
end

after "deploy:published", "deploy:restart"

# %deploy ALL= NOPASSWD: /usr/bin/systemctl ... feed_app.target

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
