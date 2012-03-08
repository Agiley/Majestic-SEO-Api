module MajesticSeo
  module Api
    module Logger

      def log(level, message)
        if ((self.respond_to?(:verbose) && self.verbose) || !self.respond_to?(:verbose))
          (defined?(Rails) && Rails.logger) ? Rails.logger.send(level, message) : puts(message)
        end
      end

    end
  end
end

