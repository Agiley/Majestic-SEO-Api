source "http://rubygems.org"

gem "faraday", ">= 0.8.7"
gem "faraday_middleware", :git => 'git://github.com/Agiley/faraday_middleware.git'
gem 'nokogiri', ">= 1.5.9"

group :development, :test do
  gem 'rspec'
  gem "mocha"
end

platforms :jruby do
  gem "jruby-openssl", ">= 0.7.7"
end

gemspec

