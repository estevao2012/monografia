require File.expand_path('../boot', __FILE__)
require 'rails/all'
#require 'active_record/connection_adapters/postgis_adapter/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SegmentacaoRodovias
  class Application < Rails::Application
    config.active_record.raise_in_transactional_callbacks = true
  end
end
