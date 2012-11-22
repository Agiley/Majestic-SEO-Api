Gem::Specification.new do |s|
  s.specification_version     = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.5") if s.respond_to? :required_rubygems_version=

  s.name = 'majestic_seo_api'
  s.version = '1.2'

  s.homepage      =   "http://developer-support.majesticseo.com/connectors/"
  s.email         =   "sebastian@agiley.se"
  s.authors       =   ["Majestic-12 Ltd", "Sebastian Johnsson"]
  s.description   =   "Interface for communicating with Majestic SEO's API"
  s.summary       =   "Interface for communicating with Majestic SEO's API"

  s.add_dependency "faraday", ">= 0.8.4"
  s.add_dependency "agiley-faraday_middleware", ">= 0.9.0"
  s.add_dependency "nokogiri", ">= 1.5.5"

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'mocha'

  # = MANIFEST =
 s.files = %w[
 Gemfile
 LICENSE.txt
 README.markdown
 Rakefile
 lib/generators/majestic_seo/majestic_seo_generator.rb
 lib/generators/templates/majestic_seo.template.yml
 lib/majestic_seo/api/client.rb
 lib/majestic_seo/api/data_table.rb
 lib/majestic_seo/api/item_info.rb
 lib/majestic_seo/api/item_info_response.rb
 lib/majestic_seo/api/logger.rb
 lib/majestic_seo/api/response.rb
 lib/majestic_seo/api/top_back_links_response.rb
 lib/majestic_seo/extensions/string.rb
 lib/majestic_seo/railtie.rb
 lib/majestic_seo_api.rb
 majestic_seo_api.gemspec
 script/get_index_item_info.rb
 script/get_top_backlinks.rb
 script/open_app_get_index_item_info.rb
 spec/majestic_seo/client_spec.rb
 spec/majestic_seo/item_info_response_spec.rb
 spec/majestic_seo/top_back_links_response_spec.rb
 spec/spec_helper.rb
 ]
 # = MANIFEST =

  s.test_files = s.files.select { |path| path =~ %r{^spec/*/.+\.rb} }
end

