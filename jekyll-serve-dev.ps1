# PowerShell script to run Jekyll with development optimizations
# Note: Live reload is disabled due to EventMachine compatibility issues with Ruby 3.3+
# Incremental regeneration still provides fast rebuilds - just refresh your browser manually

# Run Jekyll with incremental regeneration and development config
bundle exec jekyll serve --incremental --config _config.yml,_config_dev.yml

