require 'generators/helpers/file_helper'

module MajesticSeo
  module Generators
    class MajesticSeoGenerator < Rails::Generators::Base
      namespace "majestic_seo"
      source_root File.expand_path("../../templates", __FILE__)

      desc "Copies majestic_seo.yml to the Rails app's config directory."

      def copy_config
        template "majestic_seo.template.yml", "config/majestic_seo.yml"
      end

    end
  end
end

