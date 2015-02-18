source 'https://rubygems.org'
ruby '2.1.5'

gem 'bootstrap-sass'
gem 'coffee-rails'
gem 'rails', '4.1.1'
gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'pg'
gem 'bootstrap_form'
gem 'bcrypt'

gem 'figaro', '~> 1.1'
gem 'sidekiq'
gem 'rack-timeout'
gem 'sentry-raven'
gem 'paratrooper'
gem 'carrierwave'
gem 'mini_magick'
gem 'fog'
gem 'stripe'

group :development do
  gem 'thin'
  gem "better_errors"
  gem "binding_of_caller"
  gem 'letter_opener'
end

group :development, :test do
  gem 'pry'
  gem 'pry-nav'
  gem 'rspec-rails', '2.99'
  gem 'fabrication'
  gem 'faker'
end

group :test do
  gem 'database_cleaner', '1.2.0'
  gem 'shoulda-matchers', require: false
  gem 'capybara'
  gem 'capybara-email'
end

group :production do
  gem 'rails_12factor'
  gem 'unicorn'
end
