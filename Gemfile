source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.5"

gem "rails", "~> 6.1.3"
gem "sprockets-rails"
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "cpf_cnpj"
gem "jwt"
gem 'devise_token_auth', '~> 1.1'
gem 'active_model_serializers', "~> 0.10.12 "
gem "bcrypt", "~> 3.1.7"
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem "bootsnap", require: false

group :development, :test do
  gem 'rspec-rails'
  gem "rspec"
  gem "factory_bot_rails"
  gem "debug", platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem "web-console"
  gem 'letter_opener', "~> 1.7"
  gem 'rubocop'
  gem 'rubocop-performance'
  gem 'rubocop-rails'
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
  gem 'simplecov'
end
