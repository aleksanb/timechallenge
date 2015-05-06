require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
# require 'mina/rbenv'  # for rbenv support. (http://rbenv.org)
require 'mina/rvm'    # for rvm support. (http://rvm.io)

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :user, 'aleksanb'
set :domain, 'burkow.no'
set :deploy_to, '/var/www/burkow.no/challenge/'
set :repository, 'git@github.com:aleksanb/timechallenge.git'

set :branch, 'master'

# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths,
  ['log',
   'config/database.yml',
   'config/local_env.yml',
   'config/secrets.yml']

# Optional settings:
#   set :user, 'foobar'    # Username in the server to SSH to.
#   set :port, '30000'     # SSH port number.

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .rbenv-version to your repository.
  # invoke :'rbenv:load' # For those using RVM, use this to load an RVM version@gemset.
  #invoke :'rvm:use[ruby-1.9.3-p125@default]'
  set :rails_env, 'production'
  invoke :'rvm:use[ruby 2.1.1]'
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

  queue! %[mkdir -p "#{deploy_to}/shared/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]

  queue! %[touch "#{deploy_to}/shared/config/database.yml"]
  queue  %[echo "-----> Be sure to edit 'shared/config/database.yml'."]

  queue! %[touch "#{deploy_to}/shared/config/local_env.yml"]
  queue  %[echo "-----> Be sure to edit 'shared/config/local_env.yml'."]

  queue! %[touch "#{deploy_to}/shared/config/secrets.yml"]
  queue  %[echo "-----> Be sure to edit 'shared/config/secrets.rb'."]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
  end
end

namespace :sidekiq do
  desc "Start sidekiq daemon."
  task :start => :environment do
    in_directory "#{deploy_to}/current/" do
      queue %{bundle exec sidekiq -d -L log/sidekiq.log -C config/sidekiq.yml -e production}
    end
  end
end

namespace :unicorn do
  desc "Start unicorn daemon."
  task :start => :environment do
    in_directory "#{deploy_to}/current/" do
      queue %{bundle exec unicorn_rails -c config/unicorn.rb -D -E production}
    end
  end

  desc "Restart unicorn daemon."
  task :restart => :environment do
    queue %{cat /var/www/burkow.no/challenge/current/log/unicorn.pid | xargs kill -HUP}
  end
end

# For help in making your deploy script, see the Mina documentation:
#
#  - http://nadarei.co/mina
#  - http://nadarei.co/mina/tasks
#  - http://nadarei.co/mina/settings
#  - http://nadarei.co/mina/helpers

