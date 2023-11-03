source 'https://gems.railsc.ru'
source 'https://rubygems.org'

# Specify your gem's dependencies in apress-images.gemspec
gemspec

gem 'rails-assets-FileAPI', source: 'https://rails-assets.org/'
gem 'haml', '>= 4.0.7'
gem 'pg', '< 1.0.0'

if RUBY_VERSION < '2.3'
  gem 'api-auth', '< 2.3.0', require: false
  gem 'dry-auto_inject', '< 0.6.0', require: false
  gem 'dry-configurable', '< 0.8.0', require: false
  gem 'dry-container', '< 0.7.0', require: false
  gem 'nokogiri', '< 1.10.0', require: false
  gem 'pry-byebug', '< 3.7.0', require: false
  gem 'public_suffix', '< 3.1.0', require: false
  gem 'redis', '< 4.1.2', require: false
  gem 'oj', '< 3.8.0', require: false
end

if RUBY_VERSION < '2.4'
  gem 'dry-configurable', '< 0.9.0', require: false if RUBY_VERSION >= '2.3'
  gem 'mock_redis', '< 0.20', require: false
  gem 'redis-namespace', ' < 1.7.0', require: false
end

if RUBY_VERSION < '2.5'
  gem 'sprockets', '< 4.0.0'
end

# NameError: uninitialized constant Pry::Command::ExitAll при попытке выполнить require 'pry-byebug'
gem 'pry', '< 0.13.0', require: false
gem 'rspec-rails', '< 4.0.0', require: false
