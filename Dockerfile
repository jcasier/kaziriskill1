FROM ruby:2.4

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

RUN apt-get update && apt-get install -y nodejs postgresql-client vim curl --no-install-recommends &&  \
  rm -rf /var/lib/apt/lists/* &&   \
  curl -o- -L https://yarnpkg.com/install.sh|bash

ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES true
ENV RAILS_LOG_TO_STDOUT true
ENV RAILS_SERVE_STATIC_FILES 1
ENV SECRET_KEY_BASE bobo

COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
RUN bundle config --global frozen 1
RUN bundle install --without development test

COPY . /usr/src/app
RUN bundle exec rake assets:precompile

EXPOSE 3000
ENTRYPOINT ["bundle", "exec"]
CMD ["rails", "server", "-b", "0.0.0.0"]
