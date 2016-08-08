# coding: utf-8

require 'rails'
require('strong_parameters') if Rails::VERSION::MAJOR < 4
require 'addressable/uri'
require 'resque/integration'
require 'russian'
require 'paperclip'
require 'paperclip/watermark'
require 'action_view'
require 'haml'
require 'rails-assets-FileAPI'
require 'apress/api'

module Apress
  module Images
  end
end

require 'apress/images/engine'
require 'apress/images/version'
require 'apress/images/filename_cleaner'

