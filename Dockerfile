FROM fb_bundle_docker

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

ENV RAILS_ENV=production
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY . /usr/src/app

COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
RUN bundle install
CMD bundle exec rake assets:precompile ; bundle exec puma -C config/puma.rb
