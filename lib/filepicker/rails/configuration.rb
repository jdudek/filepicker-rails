require 'active_support/configurable'

module Filepicker
  module Rails
    # Configures global settings for FilepickerioRails
    #   Filepicker::Rails.configure do |config|
    #     config.api_key = 'YOURKEY'
    #   end
    def self.configure(&block)
      yield @config ||= Filepicker::Rails::Configuration.new
    end

    # Global settings for FilepickerioRails
    def self.config
      @config
    end

    # Do not access this class directly, use self.config
    class Configuration
      include ActiveSupport::Configurable
      config_accessor :api_key
    end

    # Initialize the configuration
    configure do |config|
      config.api_key = nil
    end
  end
end
