source 'https://rubygems.org'
ruby '2.3.3'

# Looking to use the Edge version? gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.1'

# Use Puma as the app server
gem 'puma', '~> 3.0'

# Use Rack Timeout. Read more: https://github.com/heroku/rack-timeout
gem 'rack-timeout', '~> 0.4'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

# Use PostgreSQL as the database for Active Record
gem 'pg', '~> 0.18'

# Use Redis Rails to set up a Redis backed Cache and / or Session
# gem 'redis-rails', '~> 5.0.0.pre'

# Use Sidekiq as a background job processor through Active Job
# gem 'sidekiq', '~> 4.2'

# Use Clockwork for recurring background tasks without needing cron
# gem 'clockwork', '~> 2.0'

# Use Kaminari for pagination
# gem 'kaminari', '~> 0.16'

# Use SCSSC for stylesheets
gem 'sassc-rails', '~> 1.3'

# Use Uglifier as the compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use jQuery as the JavaScript library
gem 'jquery-rails'

# Use coffeescript
gem 'coffee-rails', '~> 4.2.1'

# Use Turbolinks. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'

# Use Bootstrap SASS for Bootstrap support
gem 'bootstrap-sass', '~> 3.3'

# Use Font Awesome Rails for Font Awesome icons
gem 'font-awesome-rails', '~> 4.7'

# AWS SDK for signed content loading
gem 'aws-sdk', '~> 2'

# Password authentication
gem 'bcrypt', '~> 3.1', '>= 3.1.11'

# HTML Abstraction Markup Language
gem 'haml', '~> 4.0.5'

# Load .env files into ENV. Any host defined env vars will override .env file vars.
gem 'dotenv', '~> 2.2.0'

# Heroku CLI with Let's Encrypt API calls.
# Until the new API calls are generally available, you must manually specify my fork
# of the Heroku API gem:
gem 'platform-api', git: 'https://github.com/jalada/platform-api', branch: 'master'

# Let's Encrypt for SSL on Heroku
gem 'letsencrypt-rails-heroku'

# New Relic performance monitoring
gem 'newrelic_rpm'

# Email exceptions to admin
gem 'exception_notification'

# Consolidate logs
gem 'lograge'

# Background process jobs async w/o extra services
gem 'sucker_punch', '~> 2.0'

group :development, :test do
  # Call 'byebug' anywhere in your code to drop into a debugger console
  gem 'byebug', platform: :mri
end

group :development do
  # Enable a debug toolbar to help profile your application
  gem 'rack-mini-profiler', '~> 0.10'

  # Access an IRB console on exception proxy or by using <%= console %>
  gem 'web-console', '~> 3.3.0'

  # Get notified of file changes. Read more: https://github.com/guard/listen
  gem 'listen', '~> 3.0.5'

  # Use Spring. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  # Ruby linter
  gem 'rubocop'
end

group :test do
  # Test helpers
  gem 'shoulda', '~> 3.5'
  gem 'shoulda-matchers', '~> 2.0'

  gem 'minitest-reporters', '~> 1.1'
  gem 'minitest-rails-capybara', '~> 3.0'
  gem 'minitest-around', '~> 0.4.0'

  # Selenium
  gem 'selenium-webdriver', '~> 3.0'
  gem 'capybara_minitest_spec', '~> 1.0'

  # Climate control to change ENV vars
  gem 'climate_control'

  # Edit session in test
  gem 'rack_session_access'

  # Sometimes webdriver hangs hangs when loading a session - this helps with a retry instead of a test suite fail.
  gem 'minitest-retry'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
