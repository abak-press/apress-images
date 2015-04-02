# coding: utf-8

require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require 'bundler/setup'
require 'apress/images'

require 'timecop'
require 'factory_girl_rails'
require 'shoulda-matchers'
require 'paperclip/matchers'

require 'combustion'
Combustion.initialize! :all

require 'rspec/rails'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include Paperclip::Shoulda::Matchers
  config.include ActionDispatch::TestProcess

  config.use_transactional_fixtures = true
end
