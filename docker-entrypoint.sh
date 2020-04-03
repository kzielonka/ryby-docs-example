#!/bin/bash
set -e

# Fkrce bundler to use the same dir everytime
# https://bundler.io/v2.0/guides/bundler_docker_guide.html
export GEM_HOME="/usr/local/bundle"
export PATH="$GEM_HOME/bin:$GEM_HOME/gems/bin:$PATH"

# Then exec the container's main process (what's set as CMD in the Dockerfile).
case $1 in
  "setup")
    echo "SETTIG UP PROJECT"
    gem install bundler
    bundle install
    echo "APP SET UP SUCCESSFULLY"
  ;;
  "start")
    echo "SERVER RUN STARTED"
    ruby server.rb
  ;;
  "tests")
    echo "TESTS STARTED"
    bundle exec rspec
  ;;
  "doc")
    echo "GENERATING DOCS"
    bundle exec rake docs:generate
  ;;
  *)
    exec "$@"
  ;;
esac
