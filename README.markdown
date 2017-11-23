# Majestic SEO Ruby API Client #

**This is currently under heavy development (first released 2012-01-27). Get back to me if you run into any bugs.**

This is a Ruby Api client/wrapper/connector intended to be used with [Majestic SEO's awesome API](http://developer-support.majesticseo.com/).

Majestic SEO currently offers a client/connector over at [Connector Downloads](http://developer-support.majesticseo.com/connectors/downloads/) but this connector wasn't suitable for me because:

* It wasn't gemified (thus requiring a bunch of hacking to incorporate it into every respective Rails-app)
* Didn't have a config file with environment specific client settings (api key, api environment). I need to be able to use different api environments depending on the app environment
* **Didn't work with JRuby** - this gem does (or well - on 1.6.6-head and 1.7-head).
* Lacked test/spec coverage. The current test coverage isn't the best, but it's still better than nothing.

It is based on the Majestic SEO connector but has pretty much been rewritten from scratch.

The original script/test-files included now reside in script/. All of them haven't been completely upgraded yet, but they will be upgraded eventually.

## Installation ##
```
gem install majestic_seo_api
```

Generate config file:

```
rails generate majestic_seo
```
