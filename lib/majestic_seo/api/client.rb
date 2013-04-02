
=begin

  Version 0.9.3

  Copyright (c) 2011, Majestic-12 Ltd
  All rights reserved.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
  1. Redistributions of source code must retain the above copyright
  notice, this list of conditions and the following disclaimer.
  2. Redistributions in binary form must reproduce the above copyright
  notice, this list of conditions and the following disclaimer in the
  documentation and/or other materials provided with the distribution.
  3. Neither the name of the Majestic-12 Ltd nor the
  names of its contributors may be used to endorse or promote products
  derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL Majestic-12 Ltd BE LIABLE FOR ANY
  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=end

require 'uri'
require 'cgi'
require 'rubygems'
require 'faraday_middleware'

module MajesticSeo
  module Api

    class Client
      attr_accessor :connection, :api_url, :config, :api_key, :environment, :verbose
      include MajesticSeo::Api::Logger

    	def initialize(options = {})
    		set_config

    		@api_key            =   options.fetch(:api_key,     self.config.fetch("api_key", nil))
    		@environment        =   options.fetch(:environment, self.config.fetch("environment", :sandbox)).to_sym
    		@verbose            =   options.fetch(:verbose,     false)

    		set_api_url
    		set_connection
    	end

    	def set_config
    	  env           = (defined?(Rails) && Rails.respond_to?(:env)) ? Rails.env : (ENV["RACK_ENV"] || 'development')

    	  self.config   = YAML.load_file(File.join(Rails.root, "config/majestic_seo.yml"))[env] rescue nil
        self.config ||= YAML.load_file(File.join(File.dirname(__FILE__), "../../generators/templates/majestic_seo.yml"))[env] rescue nil
        self.config ||= YAML.load_file(File.join(File.dirname(__FILE__), "../../generators/templates/majestic_seo.template.yml"))[env] rescue nil
        self.config ||= {}
    	end

    	def set_api_url
        @api_url = case @environment.to_sym
          when :sandbox     then "http://developer.majesticseo.com/api_command"
          when :production  then "http://enterprise.majesticseo.com/api_command"
          else
            "http://developer.majesticseo.com/api_command"
        end
      end

    	def set_connection
    	  @connection = Faraday.new(:url => @api_url, :ssl => {:verify => false}) do |builder|
          builder.request   :url_encoded
          builder.request   :retry
          builder.response  :logger if (@verbose)
          builder.response  :nokogiri_xml
          builder.adapter   :net_http
        end
    	end

    	def get_index_item_info(urls, parameters = {}, options = {})
    	  request_parameters                    =   {}
    	  request_parameters['datasource']      =   parameters.fetch(:data_source, "historic")
        request_parameters["items"]           =   urls.size

        urls.each_with_index do |url, index|
          request_parameters["item#{index}"]  =   url
        end

        response    =   self.execute_command("GetIndexItemInfo", request_parameters, options)
        response    =   MajesticSeo::Api::ItemInfoResponse.new(response)

        return response
    	end

    	def get_top_back_links(url, parameters = {}, options = {})
        request_parameters                                  =     {}
        request_parameters['datasource']                    =     parameters.fetch(:data_source, "historic")
        request_parameters['URL']                           =     url
        request_parameters["MaxSourceURLs"]                 =     parameters.fetch(:max_source_urls, 100)
        request_parameters["ShowDomainInfo"]                =     parameters.fetch(:show_domain_info, 0)
        request_parameters["GetUrlData"]                    =     parameters.fetch(:get_url_data, 1)
        request_parameters["GetSubDomainData"]              =     parameters.fetch(:get_sub_domain_data, 0)
        request_parameters["GetRootDomainData"]             =     parameters.fetch(:get_root_domain_data, 0)
        request_parameters["MaxSourceURLsPerRefDomain"]     =     parameters.fetch(:max_source_urls_per_ref_domain, -1)
        request_parameters["DebugForceQueue"]               =     parameters.fetch(:debug_force_queue, 0)

        response    =   self.execute_command("GetTopBackLinks", request_parameters, options)
        response    =   MajesticSeo::Api::TopBackLinksResponse.new(response)

        return response
    	end

    	# This method will execute the specified command as an api request.
    	# 'name' is the name of the command you wish to execute, e.g. GetIndexItemInfo
    	# 'parameters' a hash containing the command parameters.
    	# 'timeout' specifies the amount of time to wait before aborting the transaction. This defaults to 5 seconds.
    	def execute_command(name, parameters = {}, options = {})
    		request_parameters = parameters.merge({"app_api_key" => @api_key, "cmd" => name})
    		self.execute_request(request_parameters, options)
    	end

    	# This will execute the specified command as an OpenApp request.
    	# 'command_name' is the name of the command you wish to execute, e.g. GetIndexItemInfo
    	# 'parameters' a hash containing the command parameters.
    	# 'access_token' the token provided by the user to access their resources.
    	# 'timeout' specifies the amount of time to wait before aborting the transaction. This defaults to 5 seconds.
    	def execute_open_app_request(command_name, access_token, parameters = {}, options = {})
    		request_parameters = parameters.merge({"accesstoken" => access_token, "cmd" => command_name, "privatekey" => @api_key})
    		self.execute_request(request_parameters, options)
    	end

    	# 'parameters' a hash containing the command parameters.
    	# 'options'  a hash containing command/call options (timeout, proxy settings etc)
    	def execute_request(parameters = {}, options = {})
        response = nil

        begin
          log(:info, "[MajesticSeo::Api::Client] - Sending API Request to Namecheap. Parameters: #{parameters.inspect}. Options: #{options.inspect}")
          response = @connection.get do |request|
            request.params    =   parameters  if (!parameters.empty?)
            request.options   =   options     if (!options.empty?)
          end
        rescue StandardError => e
          log(:error, "[MajesticSeo::Api::Client] - Error occurred while trying to perform API-call with parameters: #{parameters.inspect}. Error Class: #{e.class.name}. Error Message: #{e.message}. Stacktrace: #{e.backtrace.join("\n")}")
          response    =   nil
        end

    		return response
    	end

    end

  end
end

