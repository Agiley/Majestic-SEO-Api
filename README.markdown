# Majestic Ruby API Client #

Client intended to be used with [Majestic's API](http://developer-support.majesticseo.com/).

## Installation ##
```
gem install majestic_seo_api
```

## Configuration ##
```
MajesticSeoApi.configure do |config|
  config.environment  =   :production # The environment to use, valid values: :sandbox, :production
  config.api_key      =   'api_key' # Your API key provided by Majestic
  config.verbose      =   false # Set to true to enable Faraday's logging middleware to get more information
end
```

If you're using Rails, create an initializer in config/initializers/majestic.rb to configure the client globally in your app.