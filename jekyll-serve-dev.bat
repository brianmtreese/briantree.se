@echo off
REM Batch script to run Jekyll with development optimizations
REM Uses client-side auto-refresh (EventMachine C extension has compatibility issues with Ruby 3.3+)

echo Starting Jekyll with development optimizations...
echo Client-side auto-refresh enabled - browser will refresh automatically when pages are rebuilt.
echo.

REM Run Jekyll with incremental regeneration and development config
REM Client-side auto-refresh script will automatically refresh the browser when pages are rebuilt
bundle exec jekyll serve --incremental --config _config.yml,_config_dev.yml

