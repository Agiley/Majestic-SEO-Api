
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

# NOTE: The code below is specifically for the GetIndexItemInfo API command
#       For other API commands, the arguments required may differ.
#       Please refer to the Majestic SEO Developer Wiki for more information
#       regarding other API commands and their arguments.


# add the majestic seo api library to the search path
Bundler.require if defined?(Bundler)
require File.expand_path('../../lib/majestic_seo_api', __FILE__)

environment = :production

puts "\n****************************************************************************"

puts "\nEnvironment: #{environment}"

if (environment.eql?(:production))
  puts "\nThis program is hard-wired to the Enterprise API."

  puts "\nIf you do not have access to the Enterprise API, " +
    "change the environment to: \n:sandbox."
elsif (environment.eql?(:sandbox))
  puts "\nThis program is hard-wired to the Developer API " +
    "and hence the subset of data \nreturned will be substantially " +
    "smaller than that which will be returned from \neither the " +
    "Enterprise API or the Majestic SEO website."

  puts "\nTo make this program use the Enterprise API, change " +
    "the environment to: \n:production."
end

puts "\n***********************************************************" +
  "*****************";

puts "\n\nThis example program will return key information about \"index items\"." +
     "\n\nThe following must be provided in order to run this program: " +
     "\n1. API key \n2. List of items to query" +
     "\n\nPlease enter your API key:\n"

api_key = gets.chomp

puts "\nPlease enter the list of items you wish to query seperated by " +
     "commas: \n(e.g. majesticseo.com, majestic12.co.uk)\n"

items_to_query = gets.chomp
items = items_to_query.split(/,\s?/)

client = MajesticSeo::Api::Client.new(api_key, environment)
response = client.get_index_item_info(items, {:data_source => :fresh, :timeout => 5})

if (response && response.success)
  response.items.each_with_index do |item, index|
    puts "\n Result: #{index+1}: \n"
    
    instance_variables = item.instance_variables
    instance_variables.delete(:@response)
    instance_variables.delete(:@mappings)
    
    instance_variables.each do |var|
      puts " #{var.to_s.gsub("@", "")} ... #{item.instance_variable_get(var)}"
    end
    
    puts "\n"
  end if (response.items && response.items.any?)
  
  if (environment.eql?(:sandbox))
    puts "\n\n***********************************************************" +
      "*****************"

    puts "\nEnvironment: #{environment}"

    puts"\nThis program is hard-wired to the Developer API " +
      "and hence the subset of data \nreturned will be substantially " +
      "smaller than that which will be returned from \neither the " +
      "Enterprise API or the Majestic SEO website."

    puts "\nTo make this program use the Enterprise API, change " +
      "the environment to: \n:production."

    puts "\n***********************************************************" +
      "*****************"
  end
  
else
  puts "\nERROR MESSAGE:"
  puts response.error_message

  puts "\n\n***********************************************************" +
    "*****************"

  puts "\nDebugging Info:"
  puts "\n  Environment: \t#{environment}"
  puts "  API Key: \t#{api_key}"

  if(environment.eql?(:production))
    puts "\n  Is this API Key valid for this Endpoint?"

    puts "\n  This program is hard-wired to the Enterprise API."

    puts "\n  If you do not have access to the Enterprise API, " +
      "change the environment to: \n  :sandbox."
  end

  puts "\n****************************************************************************"
end