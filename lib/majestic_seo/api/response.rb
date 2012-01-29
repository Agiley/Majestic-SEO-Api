
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

module MajesticSeo
  module Api
    class Response
      attr_accessor :response, :tables, :table_key
      attr_accessor :code, :error_message, :full_error
      attr_accessor :global_variables, :success, :items

      # This method returns a new instance of the Response class.
      # If one of the parameters are not provided, it will default to nil.
      def initialize(response = nil)
        @response           =   response
        @global_variables   =   {}
        @tables             =   {}
        @success            =   false

        parse_response
      end

      def parse_response
        @response = (@response && @response.parsed_body && @response.parsed_body.root) ? @response.parsed_body.root : nil

        if (@response)
          @response.attributes.each do |key, attribute|
            self.send("#{key.underscore}=", attribute.value)
          end

          @success  =   @code.downcase.eql?("ok")

          if (success?)
            parse_global_variables
            parse_tables
          end
        end
      end

      def success?
        @success
      end

      def parse_global_variables
        vars = @response.at_xpath("//GlobalVars")

        vars.attributes.each do |key, attribute|
          @global_variables[key.underscore] = attribute.value
        end if (vars && vars.attributes.any?)
      end

      def stacktrace
        @full_error
      end

      def items
        if (@items.nil? || @items.empty?)
          @items = (self.tables && self.tables.has_key?(self.table_key)) ? self.tables[self.table_key].rows : nil
        end
        
        return @items
      end

      def parse_tables
        tables = @response.xpath("//DataTables/DataTable")

        tables.each do |table|
          parse_table(table)
        end if (tables && tables.any?)
      end

      def parse_table(table)
        parsed_table                  =   MajesticSeo::Api::DataTable.new(table)
        @tables[parsed_table.name]    =   parsed_table
      end

    end

  end
end

