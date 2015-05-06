# Setup

Install redis: http://redis.io/download.

Create a postgres user and database for the project:

Fill out the following files.
Secret_token can be generated with ```rake secret```.
Get GitHub auth tokens from https://www.github.com/ (callback should go to http://localhost:3000/auth/github/callback).

- config/database.example.yml -> config/database.yml
- config/local_env.example.yml -> config/local_env.yml
- config/initializers/secret_token.example.yml -> config/initializers/secret_token.yml

Install gems ```bundle install```.

Set up the database ```rake db:reset``` (runs create, schema load, seed).

Run sidekiq ```bundle exec sidekiq -C config/sidekiq.yml```
Run rails ```bundle exec rails server```

# Production stuff

- Run migrations (RAILS_ENV=production bundle exec rake db:migrate)
- Precompile assets (RAILS_ENV=production bundle exec rake assets:precompile)
- Change config/unicorn.rb to match your environment
- Fire up unicorn ```bundle exec unicorn_rails -c config/unicorn.rb -D -E production```
- Fire up sidekiq ```bundle exec sidekiq -c config/sidekiq.yml -D -E production```
- Add nginx listening stuff
