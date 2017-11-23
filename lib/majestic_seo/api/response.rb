module MajesticSeo
  module Api
    class Response
      attr_accessor :response, :code, :success, :error_message, :full_error, :items, :parsed_items

      def initialize(response = nil)
        self.response             =   response
        self.success              =   false
        self.items                =   []
        self.parsed_items         =   []

        parse_response
      end

      def parse_response
        if self.response.is_a?(Faraday::Response)
          self.response           =   (self.response && self.response.body) ? self.response.body : nil
          
          if self.response
            self.code             =   self.response.fetch("Code", "")
            self.success          =   self.code.downcase.eql?("ok")
            self.error_message    =   self.response.fetch("ErrorMessage", "")
            self.full_error       =   self.response.fetch("FullError", "")
          
            if success?
              self.parsed_items   =   self.response.fetch("DataTables", {}).fetch("Results", {}).fetch("Data", [])
            end
          end
        end
      end

      def success?
        self.success
      end

      def stacktrace
        self.full_error
      end

    end

  end
end

