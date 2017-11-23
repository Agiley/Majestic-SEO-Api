module MajesticSeo
  module Api
    class ItemInfo
      attr_accessor :data, :mappings
      attr_accessor :index, :type, :url, :result_code, :success, :error_message, :status
      attr_accessor :external_backlinks, :referring_domains, :indexed_urls, :analysis_results_unit_cost, :ac_rank
      attr_accessor :get_top_backlinks_analysis_results_unit_cost, :download_backlinks_analysis_results_unit_cost, :download_referring_domains_analysis_results_unit_cost
      attr_accessor :referring_ip_addresses, :referring_subnets
      attr_accessor :referring_edu_domains, :external_edu_backlinks, :referring_gov_domains, :external_gov_backlinks
      attr_accessor :exact_referring_edu_domains, :exact_external_edu_backlinks, :exact_referring_gov_domains, :exact_external_gov_backlinks
      attr_accessor :crawled, :last_crawl_date, :last_crawl_result, :redirecting, :final_redirect_result, :last_seen
      attr_accessor :outbound_domain_links, :outbound_external_backliks, :outbound_internal_backlinks, :outbound_links_pages
      attr_accessor :title, :redirecting_to
      attr_accessor :citation_flow, :trust_flow, :trust_metric
      attr_accessor :crawled_urls, :root_domain_ip_address
      attr_accessor :language_codes, :language_descriptions, :language_confidences, :language_page_ratios, :language_total_pages
      attr_accessor :referring_language_codes, :referring_language_descriptions, :referring_language_confidences, :referring_language_page_ratios, :referring_language_total_pages
      attr_accessor :total_non_unique_links, :non_unique_link_types, :non_unique_link_types_mappings
      attr_accessor :referring_domain_types, :referring_domain_types_mappings
      attr_accessor :hash_mappings
      attr_accessor :topical_trust_flows

      # This method returns a new instance of the Response class.
      # If one of the parameters are not provided, it will default to nil.
      def initialize(data)
        self.data           =   data
        
        self.mappings       =   {
          "ItemNum"                               =>    {:index                                           =>    :integer},
          "ItemType"                              =>    {:type                                            =>    :integer},
          "Item"                                  =>    {:url                                             =>    :string},
          "ResultCode"                            =>    {:result_code                                     =>    :string},
          "Status"                                =>    {:status                                          =>    :string},
          "ExtBackLinks"                          =>    {:external_backlinks                              =>    :integer},
          "RefDomains"                            =>    {:referring_domains                               =>    :integer},
          "IndexedURLs"                           =>    {:indexed_urls                                    =>    :integer},
          "AnalysisResUnitsCost"                  =>    {:analysis_results_unit_cost                      =>    :integer},
          "ACRank"                                =>    {:ac_rank                                         =>    :integer},
          "GetTopBackLinksAnalysisResUnitsCost"   =>    {:get_top_backlinks_analysis_results_unit_cost    =>    :integer},
          "DownloadBacklinksAnalysisResUnitsCost" =>    {:download_backlinks_analysis_results_unit_cost   =>    :integer},
          "DownloadRefDomainBacklinksAnalysisResUnitsCost"  => {:download_referring_domains_analysis_results_unit_cost   =>    :integer},
          "RefIPs"                                =>    {:referring_ip_addresses                          =>    :integer},
          "RefSubNets"                            =>    {:referring_subnets                               =>    :integer},
          "RefDomainsEDU"                         =>    {:referring_edu_domains                           =>    :integer},
          "ExtBackLinksEDU"                       =>    {:external_edu_backlinks                          =>    :integer},
          "RefDomainsGOV"                         =>    {:referring_gov_domains                           =>    :integer},
          "ExtBackLinksGOV"                       =>    {:external_gov_backlinks                          =>    :integer},
          "RefDomainsEDU_Exact"                   =>    {:exact_referring_edu_domains                     =>    :integer},
          "ExtBackLinksEDU_Exact"                 =>    {:exact_external_edu_backlinks                    =>    :integer},
          "RefDomainsGOV_Exact"                   =>    {:exact_referring_gov_domains                     =>    :integer},
          "ExtBackLinksGOV_Exact"                 =>    {:exact_external_gov_backlinks                    =>    :integer},
          "CrawledFlag"                           =>    {:crawled                                         =>    :boolean},
          "LastCrawlDate"                         =>    {:last_crawl_date                                 =>    :date},
          "LastCrawlResult"                       =>    {:last_crawl_result                               =>    :string},
          "RedirectFlag"                          =>    {:redirecting                                     =>    :boolean},
          "FinalRedirectResult"                   =>    {:final_redirect_result                           =>    :string},
          "LastSeen"                              =>    {:last_seen                                       =>    :string},
          "OutDomainsExternal"                    =>    {:outbound_domain_links                           =>    :integer},
          "OutLinksExternal"                      =>    {:outbound_external_backliks                      =>    :integer},
          "OutLinksInternal"                      =>    {:outbound_internal_backlinks                     =>    :integer},
          "OutLinksPages"                         =>    {:outbound_links_pages                            =>    :integer},
          "Title"                                 =>    {:title                                           =>    :string},
          "RedirectTo"                            =>    {:redirecting_to                                  =>    :string},
          "CitationFlow"                          =>    {:citation_flow                                   =>    :integer},
          "TrustFlow"                             =>    {:trust_flow                                      =>    :integer},
          "TrustMetric"                           =>    {:trust_metric                                    =>    :integer},
          "CrawledURLs"                           =>    {:crawled_urls                                    =>    :integer},
          "RootDomainIPAddress"                   =>    {:root_domain_ip_address                          =>    :string},
          "Language"                              =>    {:language_codes                                  =>    :string_array},
          "LanguageDesc"                          =>    {:language_descriptions                           =>    :string_array},
          "LanguageConfidence"                    =>    {:language_confidences                            =>    :integer_array},
          "LanguagePageRatios"                    =>    {:language_page_ratios                            =>    :float_array},
          "LanguageTotalPages"                    =>    {:language_total_pages                            =>    :integer},          
          "RefLanguage"                           =>    {:referring_language_codes                        =>    :string_array},
          "RefLanguageDesc"                       =>    {:referring_language_descriptions                 =>    :string_array},
          "RefLanguageConfidence"                 =>    {:referring_language_confidences                  =>    :integer_array},
          "RefLanguagePageRatios"                 =>    {:referring_language_page_ratios                  =>    :float_array},
          "RefLanguageTotalPages"                 =>    {:referring_language_total_pages                  =>    :integer},
          "TotalNonUniqueLinks"                   =>    {:total_non_unique_links                          =>    :integer},
        }
        
        self.non_unique_link_types            =   {}
        
        self.non_unique_link_types_mappings   =   {
          "NonUniqueLinkTypeHomepages"            =>    {:homepages                                       =>    :integer},
          "NonUniqueLinkTypeIndirect"             =>    {:indirect                                        =>    :integer},
          "NonUniqueLinkTypeDeleted"              =>    {:deleted                                         =>    :integer},
          "NonUniqueLinkTypeNoFollow"             =>    {:no_follow                                       =>    :integer},
          "NonUniqueLinkTypeProtocolHTTPS"        =>    {:https                                           =>    :integer},
          "NonUniqueLinkTypeFrame"                =>    {:frame                                           =>    :integer},
          "NonUniqueLinkTypeImageLink"            =>    {:image_link                                      =>    :integer},
          "NonUniqueLinkTypeRedirect"             =>    {:redirect                                        =>    :integer},
          "NonUniqueLinkTypeTextLink"             =>    {:text_link                                       =>    :integer},
        }
        
        self.referring_domain_types           =   {}
        
        self.referring_domain_types_mappings  =   {
          "RefDomainTypeLive"                     =>    {:live                                            =>    :integer},
          "RefDomainTypeFollow"                   =>    {:follow                                          =>    :integer},
          "RefDomainTypeHomepageLink"             =>    {:homepage_link                                   =>    :integer},
          "RefDomainTypeDirect"                   =>    {:direct                                          =>    :integer},
          "RefDomainTypeProtocolHTTPS"            =>    {:https                                           =>    :integer},
        }
        
        self.hash_mappings                    =   {
          /^NonUniqueLinkType/i                   =>  :non_unique_link_types,
          /^RefDomainType/i                       =>  :referring_domain_types
        }
        
        self.topical_trust_flows              =   {}
                
        parse_item_info
      end
      
      def parse_item_info
        self.data.each do |api_column, api_value|
          column, value   =   parse_field(self.mappings, api_column, api_value)
          self.send("#{column}=", value) if !column.nil? && !value.nil?
        end
        
        parse_hashes
        parse_topical_trust_flows
        set_result_status
        set_item_type
      end
      
      def parse_hashes
        self.data.each do |api_column, api_value|
          self.hash_mappings.each do |regex, mappings_symbol|
            if api_column =~ regex
              column_mapping    =   self.send("#{mappings_symbol}_mappings".to_sym)
              column, value     =   parse_field(column_mapping, api_column, api_value)
              self.send(mappings_symbol)[column] = value if !column.nil? && !value.nil?
            end
          end
        end
      end
      
      def parse_topical_trust_flows
        self.data.each do |api_column, api_value|
          if api_column =~ /^TopicalTrustFlow_Topic_\d*/i
            topic   =   api_value.to_s
            index   =   api_column.match(/TopicalTrustFlow_Topic_(?<index>\d*)/i)[:index].to_i
            value   =   self.data.fetch("TopicalTrustFlow_Value_#{index}", nil)
            
            self.topical_trust_flows[index] = {topic: topic, value: value.to_i} if !index.nil? && !topic.empty? && !value.nil?
          end
        end
      end
      
      def parse_field(column_mapping, api_column, api_value)
        column    =   nil
        value     =   nil
        
        mapping   =   column_mapping.fetch(api_column, nil)
        
        mapping.each do |col, data_type|
          column  =   col
          value   =   convert_value(api_value.to_s, col, data_type)
        end if mapping && !mapping.empty? && !api_value.to_s.empty?
        
        return column, value
      end
      
      def convert_value(value, column, data_type)
        return case data_type
          when :string
            value.to_s
          when :integer
            value.to_i
          when :float
            value.to_f
          when :date
            value.to_s
          when :boolean
            value.to_s.downcase.eql?("true")
          when :string_array
            value.to_s.include?(",") ? value.to_s.split(",").collect { |val| val.to_s } : [value.to_s]
          when :integer_array
            value.to_s.include?(",") ? value.to_s.split(",").collect { |val| val.to_i } : [value.to_s]
          when :float_array
            value.to_s.include?(",") ? value.to_s.split(",").collect { |val| val.to_f } : [value.to_s]
        end
      end
      
      def set_result_status
        self.success          =   (self.result_code && self.result_code.downcase.eql?("ok"))
        self.error_message    =   self.success ? "" : self.result_code
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
