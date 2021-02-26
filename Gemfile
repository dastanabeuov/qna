source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

gem 'rails', '~> 5.2.2'
gem 'rails-i18n'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'slim-rails'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem "cocoon"
gem 'devise', github: 'heartcombo/devise', branch: 'ca-omniauth-2'
gem "aws-sdk-s3", require: false
gem 'jquery-rails'
gem 'bootstrap', '~> 4.1.3'
gem 'devise-bootstrap-views'
gem 'octicons_helper'
gem 'octicons'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'skim'
gem 'omniauth'
gem "omniauth-rails_csrf_protection"
gem 'omniauth-github'
gem 'omniauth-facebook'
gem 'cancancan'
gem 'doorkeeper'
gem 'active_model_serializers', '~> 0.10'
gem 'oj'
gem 'oj_mimic_json'
gem 'responders'
gem 'sidekiq', '4.0.0'
gem 'sinatra', require: false
gem 'whenever', require: false
gem 'mysql2'
gem 'thinking-sphinx'
# gem 'mini_racer'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 3.8'
  gem 'factory_bot_rails'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  
  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-passenger', require: false
  gem 'capistrano-sidekiq', require: false
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'chromedriver-helper'
  gem 'shoulda-matchers'
  gem 'rails-controller-testing'
  gem 'launchy'
end