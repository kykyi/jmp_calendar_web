# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.5'
gem 'bootsnap', require: false
gem 'importmap-rails'
gem 'jbuilder'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'rails', '~> 7.0.8', '>= 7.0.8.1'
gem 'redis', '~> 4.0'
gem 'sprockets-rails'
gem 'stimulus-rails'
gem 'turbo-rails'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

gem 'icalendar'
gem 'roo', '~> 2.10.0'
gem 'sentry-rails'
gem 'sentry-ruby'
gem 'spreadsheet'
gem 'tailwindcss-rails', '~> 2.3'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'capybara', '~> 3.29'
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'pry'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'web-console'
end

group :test do
  gem 'database_cleaner', '~> 1.7'
  gem 'rspec'
  gem 'rspec-rails', '~> 6.1.0'
  gem 'selenium-webdriver'
end
