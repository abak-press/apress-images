# frozen_string_literal: true

source 'https://gems.railsc.ru'
source 'https://rubygems.org'

# Specify your gem's dependencies in apress-images.gemspec
gemspec

gem 'bigdecimal', '< 2', require: false
gem 'haml', '>= 4.0.7'
gem 'loofah', '< 2.20.0'
gem 'pg', '< 1.0.0'
gem 'rails-assets-FileAPI', source: 'https://rails-assets.org/'

gem 'sprockets', '< 4.0.0' if RUBY_VERSION < '2.5'

# NameError: uninitialized constant Pry::Command::ExitAll при попытке выполнить require 'pry-byebug'
gem 'pry', '< 0.13.0', require: false
gem 'rspec-rails', '< 4.0.0', require: false
