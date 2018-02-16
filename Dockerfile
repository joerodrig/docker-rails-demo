FROM ruby:2.4.2

RUN apt-get update -qq && apt-get install -y \
  build-essential \
  apt-transport-https \
  apt-utils \
  cmake \
  libpq-dev

# for nokogiri
RUN apt-get install -y libxml2-dev libxslt1-dev

# for a JS runtime
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - \
  && apt-get install -y nodejs

# yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update \
  && apt-get install -y yarn

ENV APP_HOME /tmp/docker
ADD . $APP_HOME
WORKDIR $APP_HOME

COPY . .
COPY config/database.docker.example.yml $APP_HOME/config/database.yml

ENV BUNDLE_GEMFILE=$APP_HOME/Gemfile \
  BUNDLE_JOBS=2 \
  BUNDLE_PATH=/bundle

RUN rm yarn.lock
RUN bundle install
RUN yarn install
