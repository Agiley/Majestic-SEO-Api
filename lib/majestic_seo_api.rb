require 'faraday'
require 'faraday_middleware'

module MajesticSeoApi
  require 'majestic_seo/version'
  
  if !String.instance_methods(false).include?(:underscore)
    require 'majestic_seo/extensions/string'
  end
  
  require 'majestic_seo/configuration'

  require 'majestic_seo/api/logger'
  require 'majestic_seo/api/exceptions'

  require 'majestic_seo/api/response'
  require 'majestic_seo/api/item_info_response'
  require 'majestic_seo/api/item_info'
  require 'majestic_seo/api/client'
  
  require 'majestic_seo/railtie' if defined?(Rails)
  
  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= ::MajesticSeoApi::Configuration.new
  end

  def self.reset
    @configuration = ::MajesticSeoApi::Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
