module MajesticSeoApi
  class Configuration
    attr_accessor :environment, :api_key, :verbose
    
    def initialize
      self.environment  =   :sandbox
      self.api_key      =   nil
      self.verbose      =   false
    end
    
  end
end
