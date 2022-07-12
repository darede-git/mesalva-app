FROM ruby:2.6.6

RUN apt-get update
RUN apt-get install libpq-dev nodejs npm python make build-essential g++ gcc libxslt-dev libxml2-dev libcurl4-openssl-dev libavahi-compat-libdnssd-dev curl wget git imagemagick -y

ENV RAILS_ENV=production

RUN gem install bundler:2.2.21

WORKDIR /app

COPY package* ./
RUN npm install

COPY Gemfile* ./
RUN bundle install

COPY . .

# COPY .env.sample .env
# COPY config/database.yml.sample config/database.yml

EXPOSE 3000

CMD bundle exec rails s -b 0.0.0.0
