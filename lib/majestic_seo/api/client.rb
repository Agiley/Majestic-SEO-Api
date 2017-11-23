module MajesticSeo
  module Api

    class Client
      attr_accessor :connection, :api_url
      include MajesticSeo::Api::Logger

    	def initialize
    		set_api_url
    		set_connection
    	end
      
    	def set_api_url(format = :json)
        self.api_url      =   case ::MajesticSeoApi.configuration.environment.to_sym
          when :sandbox     then "http://developer.majestic.com/api/#{format}"
          when :production  then "http://api.majestic.com/api/#{format}"
          else
            "http://developer.majestic.com/api/#{format}"
        end
      end

    	def set_connection
    	  self.connection = Faraday.new(url: self.api_url, ssl: {verify: false}) do |builder|
          builder.request  :url_encoded
          builder.request  :retry
          builder.response :json
          builder.response :logger if ::MajesticSeoApi.configuration.verbose
          builder.adapter  :net_http
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
        raise "Not implemented yet!"
        
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

        #response    =   self.execute_command("GetTopBackLinks", request_parameters, options)
        #response    =   MajesticSeo::Api::TopBackLinksResponse.new(response)

        #return response
    	end

    	# This method will execute the specified command as an api request.
    	# 'name' is the name of the command you wish to execute, e.g. GetIndexItemInfo
    	# 'parameters' a hash containing the command parameters.
    	# 'timeout' specifies the amount of time to wait before aborting the transaction. This defaults to 5 seconds.
    	def execute_command(name, parameters = {}, options = {})
    		request_parameters = parameters.merge({"app_api_key" => ::MajesticSeoApi.configuration.api_key, "cmd" => name})
    		self.execute_request(request_parameters, options)
    	end

    	# This will execute the specified command as an OpenApp request.
    	# 'command_name' is the name of the command you wish to execute, e.g. GetIndexItemInfo
    	# 'parameters' a hash containing the command parameters.
    	# 'access_token' the token provided by the user to access their resources.
    	# 'timeout' specifies the amount of time to wait before aborting the transaction. This defaults to 5 seconds.
    	def execute_open_app_request(command_name, access_token, parameters = {}, options = {})
    		request_parameters = parameters.merge({"accesstoken" => access_token, "cmd" => command_name, "privatekey" => ::MajesticSeoApi.configuration.api_key})
    		self.execute_request(request_parameters, options)
    	end

    	# 'parameters' a hash containing the command parameters.
    	# 'options'  a hash containing command/call options (timeout, proxy settings etc)
    	def execute_request(parameters = {}, options = {}, retries = 3)
        response        =   nil
        timeout         =   options.delete(:timeout)      { |opt| 60 }
        open_timeout    =   options.delete(:open_timeout) { |opt| 60 }
        
        begin
          log(:info, "[MajesticSeo::Api::Client] - Sending API Request to Majestic SEO. Parameters: #{parameters.inspect}. Options: #{options.inspect}")
          
          response      =   self.connection.get do |request|
            request.params                    =   parameters  if !parameters.empty?
            request.options                   =   options     if !options.empty?
            request.options[:timeout]         =   timeout
            request.options[:open_timeout]    =   open_timeout
          end
        
        rescue Faraday::Error => e
          log(:error, "[MajesticSeo::Api::Client] - Error occurred while trying to perform API-call with parameters: #{parameters.inspect}. Error Class: #{e.class.name}. Error Message: #{e.message}. Stacktrace: #{e.backtrace.join("\n")}")
          retries -= 1
          
          if retries > 0
            retry
          else
            raise e
          end
        end

    		return response
    	end

    end

  end
end
