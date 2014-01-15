require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)

module Tracksimply
  class Application < Rails::Application
    # not sure why this isn't being autoloaded
    config.autoload_paths += %W(#{config.root}/services)

    config.time_zone = 'Pacific Time (US & Canada)'

    config.generators do |g|
      g.helper false
    end
  end
end
