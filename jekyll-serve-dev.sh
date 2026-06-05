#!/usr/bin/env bash

# Shell script to run Jekyll with development optimizations on macOS/Linux.
# Uses client-side auto-refresh when pages are rebuilt.

set -euo pipefail

clean=false

for arg in "$@"; do
  case "$arg" in
    --clean|-clean)
      clean=true
      ;;
    *)
      echo "Unknown option: $arg"
      echo "Usage: ./jekyll-serve-dev.sh [--clean]"
      exit 1
      ;;
  esac
done

# Prefer Homebrew Ruby on macOS so we do not accidentally use system Ruby.
if [[ -d "/opt/homebrew/opt/ruby/bin" ]]; then
  export PATH="/opt/homebrew/opt/ruby/bin:/opt/homebrew/lib/ruby/gems/4.0.0/bin:$PATH"
fi

if [[ "$clean" == true ]]; then
  echo "Clearing Jekyll cache..."
  if [[ -d ".jekyll-cache" ]]; then
    rm -rf ".jekyll-cache"
    echo "Cache cleared."
  fi
  if [[ -d "_site" ]]; then
    rm -rf "_site"
    echo "Site directory cleared."
  fi
  echo "Starting fresh build..."
  echo
fi

echo "Starting Jekyll with development optimizations..."
echo "Client-side auto-refresh enabled - browser will refresh automatically when pages are rebuilt."
echo
echo "TIP: If a new post doesn't appear, stop the server and run: ./jekyll-serve-dev.sh --clean"
echo

bundle exec jekyll serve --incremental --config _config.yml,_config_dev.yml
