# Majestic SEO Ruby API Client #

**This is currently under heavy development (first released 2012-01-27). Get back to me if you run into any bugs.**

This is a Ruby Api client/wrapper/connector intended to be used with [Majestic SEO's awesome API](http://developer-support.majesticseo.com/).

Majestic SEO currently offers a client/connector over at [Connector Downloads](http://developer-support.majesticseo.com/connectors/downloads/) but this connector wasn't suitable for me because:

* It wasn't gemified (thus requiring a bunch of hacking to incorporate it into every respective Rails-app)
* Didn't have a config file with environment specific client settings (api key, api environment). I need to be able to use different api environments depending on the app environment
* **Didn't work with JRuby** - this gem does (or well - on 1.6.6-head and 1.7-head).
* Lacked test/spec coverage. The current test coverage isn't the best, but it's still better than nothing.

It is based on the Majestic SEO connector but has pretty much been rewritten from scratch.

The original script/test-files included now reside in script/. All of them haven't been completely upgraded yet, but they will.

## Installation ##
Add to your Gemfile:
```
gem 'majestic_seo_api', :git => 'git://github.com/Agiley/Majestic-SEO-Api.git'
```

Generate config file:
```
rails generate majestic_seo
```

## Tested on ##
The specs pass on:

* Ruby 1.9.2
* Ruby 1.9.3
* JRuby 1.6.6-head
* JRuby 1.7-head

*JRuby 1.6.5/1.6.5.1 does not work :(*

## License ##
Original Majestic SEO License:

---------

Copyright (c) 2011, Majestic-12 Ltd

All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
* Neither the name of the Majestic-12 Ltd nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL Majestic-12 Ltd BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

---------

