# syntax=docker/dockerfile:1
# check=error=true

# This Dockerfile is designed for production, not development. Use with Kamal or build'n'run by hand:
# docker build -t dada_final .
# docker run -d -p 80:80 -e RAILS_MASTER_KEY=<value from config/master.key> --name dada_final dada_final

# For a containerized dev environment, see Dev Containers: https://guides.rubyonrails.org/getting_started_with_devcontainer.html

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG RUBY_VERSION=3.3.0
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# Rails app lives here
FROM ruby:3.2

# Install dependencies
RUN apt-get update -qq && \
    apt-get install -y build-essential libsqlite3-dev nodejs yarn

# Set working directory
WORKDIR /app

# Copy Gemfiles and install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy the rest of the app
COPY . .

# Precompile assets (if using)
RUN bundle exec rake assets:precompile || true

# Expose port 3000
EXPOSE 3000

# Start the Rails server
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
