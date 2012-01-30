
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
    class ItemInfo
      attr_accessor :response, :mappings
      attr_accessor :index, :type, :url, :result_code, :success, :error_message, :status
      attr_accessor :external_backlinks, :referring_domains, :indexed_urls, :analysis_results_unit_cost, :ac_rank
      attr_accessor :get_top_backlinks_analysis_results_unit_cost, :referring_ip_addresses, :referring_subnets
      attr_accessor :referring_edu_domains, :external_edu_backlinks, :referring_gov_domains, :external_gov_backlinks
      attr_accessor :exact_referring_edu_domains, :exact_external_edu_backlinks, :exact_referring_gov_domains, :exact_external_gov_backlinks
      attr_accessor :crawled, :last_crawl_date, :last_crawl_result, :redirecting, :final_redirect_result
      attr_accessor :outbound_domain_links, :outbound_external_backliks, :outbound_internal_backlinks
      attr_accessor :title, :redirecting_to

      # This method returns a new instance of the Response class.
      # If one of the parameters are not provided, it will default to nil.
      def initialize(response = nil)
        self.response           =   response
        
        self.mappings = {
          "ItemNum"                               =>    {:index                                         =>    :integer},
          "ItemType"                              =>    {:type                                          =>    :integer},
          "Item"                                  =>    {:url                                           =>    :string},
          "ResultCode"                            =>    {:result_code                                   =>    :string},
          "Status"                                =>    {:status                                        =>    :string},
          "ExtBackLinks"                          =>    {:external_backlinks                            =>    :integer},
          "RefDomains"                            =>    {:referring_domains                             =>    :integer},
          "IndexedURLs"                           =>    {:indexed_urls                                  =>    :integer},
          "AnalysisResUnitsCost"                  =>    {:analysis_results_unit_cost                    =>    :integer},
          "ACRank"                                =>    {:ac_rank                                       =>    :integer},
          "GetTopBackLinksAnalysisResUnitsCost"   =>    {:get_top_backlinks_analysis_results_unit_cost  =>    :integer},
          "RefIPs"                                =>    {:referring_ip_addresses                        =>    :integer},
          "RefSubNets"                            =>    {:referring_subnets                             =>    :integer},
          "RefDomainsEDU"                         =>    {:referring_edu_domains                         =>    :integer},
          "ExtBackLinksEDU"                       =>    {:external_edu_backlinks                        =>    :integer},
          "RefDomainsGOV"                         =>    {:referring_gov_domains                         =>    :integer},
          "ExtBackLinksGOV"                       =>    {:external_gov_backlinks                        =>    :integer},
          "RefDomainsEDU_Exact"                   =>    {:exact_referring_edu_domains                   =>    :integer},
          "ExtBackLinksEDU_Exact"                 =>    {:exact_external_edu_backlinks                  =>    :integer},
          "RefDomainsGOV_Exact"                   =>    {:exact_referring_gov_domains                   =>    :integer},
          "ExtBackLinksGOV_Exact"                 =>    {:exact_external_gov_backlinks                  =>    :integer},
          "CrawledFlag"                           =>    {:crawled                                       =>    :boolean},
          "LastCrawlDate"                         =>    {:last_crawl_date                               =>    :date},
          "LastCrawlResult"                       =>    {:last_crawl_result                             =>    :string},
          "RedirectFlag"                          =>    {:redirecting                                   =>    :boolean},
          "FinalRedirectResult"                   =>    {:final_redirect_result                         =>    :string},
          "OutDomainsExternal"                    =>    {:outbound_domain_links                         =>    :integer},
          "OutLinksExternal"                      =>    {:outbound_external_backliks                    =>    :integer},
          "OutLinksInternal"                      =>    {:outbound_internal_backlinks                   =>    :integer},
          "Title"                                 =>    {:title                                         =>    :string},
          "RedirectTo"                            =>    {:redirecting_to                                =>    :string},
        }
        
        parse_item_info
      end
      
      def parse_item_info
        self.response.each do |api_column, api_value|
          mapping   =   self.mappings[api_column]
          value     =   (!api_value.nil? && !api_value.to_s.eql?("")) ? api_value.to_s : nil
          
          mapping.each do |column, data_type|
            converted_value = case data_type
              when :string    then value
              when :integer   then value.to_i
              when :date      then value #Return it as a string for now - need to be able to retrieve a result with a date set to determine date parsing format
              when :boolean   then (value.downcase.eql?("true"))
            end
            
            self.send("#{column}=", converted_value)
          end if (value)
        end
        
        set_result_status
        set_item_type
      end
      
      def set_result_status
        self.success          =   (self.result_code && self.result_code.downcase.eql?("ok"))
        self.error_message    =   (self.success) ? "" : self.result_code
      end
      
      def set_item_type
        self.type = case self.type
          when 1 then :root_domain
          when 2 then :sub_domain
          when 3 then :url
        end
      end

    end

  end
end

