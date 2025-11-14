@echo off
REM Batch script to run Jekyll with development optimizations
REM Uses client-side auto-refresh (EventMachine C extension has compatibility issues with Ruby 3.3+)

REM Check for --clean argument
if "%1"=="--clean" (
    echo Clearing Jekyll cache...
    if exist ".jekyll-cache" (
        rmdir /s /q ".jekyll-cache"
        echo Cache cleared.
    )
    if exist "_site" (
        rmdir /s /q "_site"
        echo Site directory cleared.
    )
    echo Starting fresh build...
    echo.
)

echo Starting Jekyll with development optimizations...
echo Client-side auto-refresh enabled - browser will refresh automatically when pages are rebuilt.
echo.
echo TIP: If a new post doesn't appear, stop the server and run: .\jekyll-serve-dev.bat --clean
echo.

REM Run Jekyll with incremental regeneration and development config
REM --force_polling helps with file detection on Windows, especially for new files
REM Client-side auto-refresh script will automatically refresh the browser when pages are rebuilt
bundle exec jekyll serve --incremental --force_polling --config _config.yml,_config_dev.yml

