
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
    class DataTable
      attr_accessor :node, :name, :row_count, :headers, :rows
      
      def initialize(node)
        @node         =   node

        if (@node)
          @name       =   @node["Name"]       ||  nil
          @row_count  =   @node["RowsCount"]  ||  0
          @headers    =   @node["Headers"]    ||  []

          @rows       =   []
          parse
        end
      end

      def parse
        rows = @node.xpath("Row")

        if (@headers && rows && rows.any?)
          @headers = split(@headers)

          rows.each do |row|
            parse_row(row)
          end
        end
      end

      def parse_row(row)
        if (row && row.content)
          row           =   row.content
          row_hash      =   {}
          splitted_row  =   split(row, true)
          
          @headers.each_with_index do |header, index|
            value               =   splitted_row[index].strip
            value               =   (value && value != "") ? value : nil
            
            #If the title element contains a |-sign (the separator) the title will be splitted into two rows, thus breaking the parsing of the remaining rows
            if (header.eql?("Title") && splitted_row.size > @headers.size)
              remaining_title   =   splitted_row.delete_at(index+1).strip
              value            +=   remaining_title if value
            end
            
            row_hash[header]    =   value
          end

          @rows << row_hash if (row_hash && !row_hash.empty?)
        end
      end

      def split(text, remove_excess_separators = false)
        text        =   text.gsub(/\|{2,}/i, "|") if remove_excess_separators
        splitted    =   text.split(/\|(?!\|)/)
      end

      def row_count
        @rows.length
      end

    end
  end
end

