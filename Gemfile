source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.3'

gem 'rails', '5.2.5'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'bcrypt'
gem 'bootsnap', '>= 1.4.4', require: false

group :development, :test do
  gem 'rspec-rails'
  gem 'pry'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'shoulda-matchers'
  gem 'simplecov'
  gem 'fast_jsonapi'
  gem 'faraday'
  gem 'figaro'
end

group :development do
  gem 'listen', '~> 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :test do
  gem 'webmock'
  gem 'vcr'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
