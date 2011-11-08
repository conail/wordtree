require File.expand_path('../boot', __FILE__)
require 'rails/all'

Bundler.require *Rails.groups(:assets => %w(development test)) if defined?(Bundler)

module PrototypeThewordtreeNet
  class Application < Rails::Application
    config.encoding = 'utf-8'
    config.filter_parameters += [:password]
    config.assets.enabled = true
    config.assets.version = '1.0'
  end
end
