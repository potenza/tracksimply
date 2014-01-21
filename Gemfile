ruby '2.1.0'

source 'https://rubygems.org'

gem 'foreman'
gem 'rails', '4.1.0.beta1'
gem 'pg'
gem 'sass-rails', '~> 4.0.0.rc1'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'bcrypt-ruby', '~> 3.1.2'
gem 'unicorn'

gem 'sidekiq'
gem 'bootstrap-sass'
gem 'bourbon'
gem 'bootstrap_form', git: 'git://github.com/potenza/bootstrap_form.git', branch: 'rails-4.1.0'
gem 'bootstrap-datepicker-rails'
gem 'carrierwave'
gem 'fog', '~> 1.3.1'
gem 'chronic'

group :development do
  gem 'spring', '1.0.0'
  gem 'sinatra', '>= 1.3.0', :require => nil # sidekiq
end

group :test do
  gem 'mocha', require: false
  gem 'capybara'
  gem 'poltergeist'
  gem 'simplecov'
  gem 'launchy' # save_and_open_page
end

gem 'rails_12factor', group: :production
