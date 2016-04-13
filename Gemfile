source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.2.6'

# Use SCSS for stylesheets
gem 'sass-rails'#, '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'#, '>= 1.3.0'

# Use Haml for html compilation
gem 'haml'

# Use Formtastic for better forms
gem 'formtastic'

# Use omniauth for authentication
gem 'omniauth'
gem 'omniauth-github'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Entire thoughtbot stack
gem 'bourbon'
gem 'neat'
gem 'bitters'

# Allow separate date and time assignments for datetime
gem 'time_splitter'

#For date validation
gem 'date_validator'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Authorization plugin
gem 'declarative_authorization'

# Postgres as database gem
gem 'pg'

# Queue manager for ActiveJob
gem 'sidekiq'
gem 'sinatra', require: false
gem 'slim'

group :production do
  # L33t webserver
  gem 'unicorn'
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :development do
  # Live reload of webpage on changes
  gem 'guard'
  gem 'guard-livereload', require: false
  gem 'rack-livereload'

  # Annotating of models
  gem 'annotate'

  # Simple command execution over SSH. Lightweight deployment tool.
  gem 'mina'
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use debugger
# gem 'debugger', group: [:development, :test]
