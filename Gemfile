source 'https://rubygems.org'

gem "jekyll", "~> 3.9.3"
gem "jekyll-paginate"
gem "webrick", "~> 1.7"
gem "kramdown-parser-gfm"
gem "nokogiri", "~> 1.15.7"
gem "mini_portile2", "~> 2.8.8"
gem "http_parser.rb", "~> 0.6.0"
# EventMachine - use pure-ruby on Windows if C extension fails
gem "eventmachine", "~> 1.2.7"

group :jekyll_plugins do
  gem "jekyll-sass-converter", "~> 1.5.2"
  gem "jekyll-seo-tag"
  gem "jekyll-sitemap"
  gem "jekyll-feed"
end

# Windows-specific gems
platforms :mingw, :x64_mingw, :mswin do
  gem 'tzinfo-data'
  gem 'wdm', '>= 0.1.0'  # Windows Directory Monitor for faster file watching
end

# Ruby 3.4+ compatibility: These libraries are being removed from Ruby's standard library
# Jekyll dependencies (safe_yaml, liquid) require these, so we add them as gems
gem 'csv'
gem 'base64'
gem 'bigdecimal'

# Required for EventMachine pure Ruby mode on Ruby 3.3+
# SortedSet was removed from Ruby's standard library
gem 'sorted_set'