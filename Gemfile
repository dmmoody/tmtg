source 'https://rubygems.org'

ruby '3.3.0'

# Environment Variables
gem 'dotenv-rails', groups: [:development, :test]

gem 'rails', '~> 7.1.3'

# Rail Core Gems
gem 'bcrypt', '~> 3.1.7'
gem 'bootsnap', require: false
gem 'importmap-rails'
gem 'jbuilder'
gem 'kredis'
gem 'pg', '~> 1.1'
gem 'puma', '>= 5.0'
gem 'redis', '>= 4.0.1'
gem 'sprockets-rails'
gem 'stimulus-rails'
gem 'turbo-rails'
gem 'tzinfo-data', platforms: %i[ windows jruby ]

# Logging
gem 'amazing_print'
gem 'rails_semantic_logger'

# HTTP Client
gem 'faraday'
gem 'faraday_middleware'

# Jobs
gem 'sidekiq'

group :development, :test do
  gem 'debug', platforms: %i[ mri windows ]
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'foreman'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-rails', '~> 6.1.0'
  gem 'rubocop', require: false
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
end

group :development do
  gem 'rack-mini-profiler'
  gem 'spring'
  gem 'web-console'
end

group :test do
  gem 'rails-controller-testing'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
end