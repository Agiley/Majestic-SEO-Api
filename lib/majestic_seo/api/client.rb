
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

module MajesticSeo
  module Api

    class Client
      attr_accessor :http_client, :config, :api_key, :environment
      include MajesticSeo::Api::Logger

    	def initialize(api_key = nil, environment = nil)
    		@http_client        =   ::HttpUtilities::Http::Client.new
    		set_config

    		@api_key            =   api_key       ||  self.config.fetch("api_key", nil)
    		@environment        =   environment   ||  self.config.fetch("environment", :sandbox)
    		@environment        =   @environment.to_sym
    	end

    	def set_config
    	  rails_env     =   defined?(Rails) ? Rails.env : "development"
    	  self.config   = YAML.load_file(File.join(Rails.root, "config/majestic_seo.yml"))[rails_env] rescue nil
        self.config ||= YAML.load_file(File.join(File.dirname(__FILE__), "../../generators/templates/majestic_seo.yml"))[rails_env] rescue nil
        self.config ||= YAML.load_file(File.join(File.dirname(__FILE__), "../../generators/templates/majestic_seo.template.yml"))[rails_env] rescue nil
        self.config ||= {}
    	end

    	def get_index_item_info(urls, parameters = {})
    	  request_parameters                    =   {}
    	  request_parameters['datasource']      =   parameters.fetch(:data_source, "historic")
        request_parameters["items"]           =   urls.size

        urls.each_with_index do |url, index|
          request_parameters["item#{index}"]  =   url
        end

        timeout     =   parameters.fetch(:timeout, 5)
        response    =   self.execute_command("GetIndexItemInfo", request_parameters, timeout)
        response    =   MajesticSeo::Api::ItemInfoResponse.new(response)

        return response
    	end

    	def get_top_back_links(url, parameters = {})
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

        timeout     =   parameters.fetch(:timeout, 5)
        response    =   self.execute_command("GetTopBackLinks", request_parameters, timeout)
        response    =   MajesticSeo::Api::TopBackLinksResponse.new(response)

        return response
    	end

    	def api_url
        return case @environment.to_sym
          when :sandbox     then "http://developer.majesticseo.com/api_command"
          when :production  then "http://enterprise.majesticseo.com/api_command"
          else
            "http://developer.majesticseo.com/api_command"
        end
      end

    	# This method will execute the specified command as an api request.
    	# 'name' is the name of the command you wish to execute, e.g. GetIndexItemInfo
    	# 'parameters' a hash containing the command parameters.
    	# 'timeout' specifies the amount of time to wait before aborting the transaction. This defaults to 5 seconds.
    	def execute_command(name, parameters, timeout = 5)
    		query_parameters = parameters.merge({"app_api_key" => @api_key, "cmd" => name})
    		self.execute_request(query_parameters, timeout)
    	end

    	# This will execute the specified command as an OpenApp request.
    	# 'command_name' is the name of the command you wish to execute, e.g. GetIndexItemInfo
    	# 'parameters' a hash containing the command parameters.
    	# 'access_token' the token provided by the user to access their resources.
    	# 'timeout' specifies the amount of time to wait before aborting the transaction. This defaults to 5 seconds.
    	def execute_open_app_request(command_name, parameters, access_token, timeout = 5)
    		query_parameters = parameters.merge({"accesstoken" => access_token, "cmd" => command_name, "privatekey" => @api_key})
    		self.execute_request(query_parameters, timeout)
    	end

    	# 'parameters' a hash containing the command parameters.
    	# 'timeout' specifies the amount of time to wait before aborting the transaction. This defaults to 5 seconds.
    	def execute_request(query_parameters, timeout = 5)
    		query, response = "", nil

    		query_parameters.each do |key, value|
    		  encoded_value = CGI.escape(value.to_s).gsub("+", "%20").gsub("%7E", "~")
    		  query << "#{key}=#{encoded_value}&"
    		end

    		query   =   query.chop
    		url     =   "#{api_url}?#{query}"
    		options =   {:timeout => timeout, :format => :xml}

    		begin
    		  response = self.http_client.retrieve_content_from_url(url, options)

    		rescue Exception => e
    		  log(:error, "[MajesticSeo::Api::Client] - Error occurred while trying to execute request. Error Class: #{e.class.name}. Error Message: #{e.message}. Stacktrace: #{e.backtrace.join("\n")}")
    		end

    		return response
    	end

    end

  end
end

