require File.expand_path('../boot', __FILE__)

require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'active_resource/railtie'
require 'rails/test_unit/railtie'
require 'neo4j'
require 'will_paginate/railtie'

if defined?(Bundler)
  Bundler.require *Rails.groups(:assets => %w(development test))
end

module PrototypeThewordtreeNet
  class Application < Rails::Application
    config.encoding = 'utf-8'
    config.filter_parameters += [:password]
    config.generators do |g|
      g.orm             :neo4j
      g.test_framework  :rspec, :fixture => false
    end
    config.neo4j.storage_path = "#{config.root}/db/neo4j-#{Rails.env}"
    config.neo4j.timestamps = false
    config.assets.enabled = true
    config.assets.version = '1.0'
  end
end
