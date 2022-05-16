source 'https://gems.railsc.ru'
source 'https://rubygems.org'

gem 'actionpack', '< 5.0.0', require: false

# Specify your gem's dependencies in apress-images.gemspec
gemspec

gem "haml", ">= 4.0.7"

gem 'pg', '< 1.0.0'

if RUBY_VERSION < '2.5'
  gem 'sprockets', '< 4.0.0'
  gem 'nokogiri', '< 1.11.0', require: false
  gem 'api-auth', '< 2.5.0', require: false
end
# NameError: uninitialized constant Pry::Command::ExitAll при попытке выполнить require 'pry-byebug'
gem 'pry', '< 0.13.0', require: false
