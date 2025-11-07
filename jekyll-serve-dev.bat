@echo off
REM Batch script to run Jekyll with development optimizations
REM Note: Live reload is disabled due to EventMachine compatibility issues with Ruby 3.3+
REM Incremental regeneration still provides fast rebuilds - just refresh your browser manually

echo Starting Jekyll with development optimizations...
echo Note: Live reload is disabled. Incremental regeneration is enabled for fast rebuilds.
echo Just refresh your browser after making changes.
echo.

REM Run Jekyll with incremental regeneration and development config (no livereload due to EventMachine issues)
bundle exec jekyll serve --incremental --config _config.yml,_config_dev.yml

