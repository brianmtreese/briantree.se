source 'https://rubygems.org'

gem "jekyll", "~> 3.9.3"
gem "jekyll-paginate"
gem "webrick", "~> 1.7"
gem "kramdown-parser-gfm"
gem "nokogiri", "~> 1.15.5", platforms: [:x64_mingw]

group :jekyll_plugins do
  gem "jekyll-sass-converter", "~> 1.5.2"
  gem "jekyll-sitemap"
  gem "jekyll-gist"
  gem "jekyll-feed"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw]

# Windows Directory Monitor (WDM) gem
gem 'wdm', '>= 0.1.0' if Gem.win_platform?

# For Ruby 3.0 or higher on Windows
gem "eventmachine", "~> 1.2.7", platforms: [:mingw, :x64_mingw]
gem "http_parser.rb", "~> 0.6.0"

# Lock `http_parser.rb` gem to `