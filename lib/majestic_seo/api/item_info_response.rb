module MajesticSeo
  module Api
    class ItemInfoResponse < Response
      
      def initialize(response)
        super(response)
        
        raise_exceptions_if_necessary
        parse_item_info_objects
      end
      
      def raise_exceptions_if_necessary
        case self.code
          when 'InsufficientIndexItemInfoUnits'
            raise MajesticSeo::Api::InsufficientIndexItemInfoUnitsException.new(self.error_message)
        end unless success?
      end
      
      def parse_item_info_objects
        self.parsed_items.each do |parsed_item|
          item_info   =   MajesticSeo::Api::ItemInfo.new(parsed_item)
          self.items <<   item_info unless self.items.include?(item_info)
        end if self.parsed_items && self.parsed_items.any?
      end
      
    end
  end
end
