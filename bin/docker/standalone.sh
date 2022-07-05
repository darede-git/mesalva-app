#!/bin/sh

bundle && \
bundle exec rake db:environment:set RAILS_ENV=test && \
bundle exec rake db:drop && \
bundle exec rake db:create && \
bundle exec rake db:migrate && \
bundle exec rake db:seed:integration && \
rm -f tmp/pids/server.pid && \
dpkg-reconfigure -f noninteractive tzdata && \
bundle exec rails s -b 0.0.0.0 -p 3000
