# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

gem 'bootsnap', '>= 1.4.2', require: false
gem 'bootstrap', '~> 5.0.0.alpha1'
gem 'dry-struct'
gem 'dry-types'
gem 'jbuilder', '~> 2.7'
gem 'pg', '~> 1.2.3'
gem 'puma', '~> 4.1'
gem 'rails', '~> 6.0.3', '>= 6.0.3.2'
gem 'rails_event_store', '~> 1.1.0'
gem 'sass-rails', '>= 6'
gem 'turbolinks', '~> 5'
gem 'webpacker', '~> 4.0'

group :development, :test do
  gem 'dotenv', '~> 2.7.6'
  gem 'pry', '~> 0.13.1'
end

group :development do
  gem 'listen', '~> 3.2'
  gem 'rubocop', '~> 0.89.1'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'rspec-rails', '~> 4.0.1'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
