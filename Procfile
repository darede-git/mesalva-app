web:    cp config/database.yml.sample config/database.yml && bundle exec puma -C config/puma.rb
worker: cp config/database.yml.sample config/database.yml && bundle exec sidekiq -C config/sidekiq.yml
clock:  cp config/database.yml.sample config/database.yml && bundle exec clockwork clock.rb
