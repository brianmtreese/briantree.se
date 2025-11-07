# PowerShell script to run Jekyll with development optimizations
# Uses client-side auto-refresh (EventMachine C extension has compatibility issues with Ruby 3.3+)

# Run Jekyll with incremental regeneration and development config
# Client-side auto-refresh script will automatically refresh the browser when pages are rebuilt
bundle exec jekyll serve --incremental --config _config.yml,_config_dev.yml

