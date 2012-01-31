module MajesticSeoApi
  VERSION = "1.1.2"

  require File.join(File.dirname(__FILE__), 'majestic_seo/railtie') if defined?(Rails)

  if (!String.instance_methods(false).include?(:underscore))
    require File.join(File.dirname(__FILE__), 'majestic_seo/extensions/string')
  end

  require File.join(File.dirname(__FILE__), 'majestic_seo/api/logger')

  require File.join(File.dirname(__FILE__), 'majestic_seo/api/response')
  require File.join(File.dirname(__FILE__), 'majestic_seo/api/item_info_response')
  require File.join(File.dirname(__FILE__), 'majestic_seo/api/top_back_links_response')
  require File.join(File.dirname(__FILE__), 'majestic_seo/api/data_table')
  require File.join(File.dirname(__FILE__), 'majestic_seo/api/item_info')
  require File.join(File.dirname(__FILE__), 'majestic_seo/api/client')
end

