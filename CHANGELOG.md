### master

### 0.1.10 / 2013-07-07

Fixing Regression

### 0.1.9 / 2013-07-07

Bug Fixes

* Change middleware insert order to work with config.threadsafe! (thnx [Nick Urban!](https://github.com/nickurban))

### 0.1.1 / 2012-01-18

[full changelog](https://github.com/rubymaverick/font_assets/compare/v0.1.0...v0.1.1)

Bug Fixes

* Fix Rack::File#empty? call in middleware causing an exception.

### 0.1.0 / 2012-01-18

[full changelog](https://github.com/rubymaverick/font_assets/compare/v0.0.2...v0.1.0)

Enhancements

* Refactor MIME type settings into a local object.
* Add RSpec specs on the middleware and mime type handler.
* Update the README with more detail and examples.
* Fixed a typo in "ttf" in the middleware.
* Removed duplicate Railtie definition.

Bug Fixes

* Fix MIME types not being properly set in recent versions of Rack (starting in [Rack 1.3.0](https://github.com/rack/rack/commit/469518f7d971ba99fc335cf546d605d2364c81aa))

### 0.0.2 / 2011-12-15

[full changelog](https://github.com/rubymaverick/font_assets/compare/v0.0.1...v0.0.2)

Enhancements

* Make MIME setting more future-compatible by optionally setting it.

### 0.0.1 / 2011-12-15

Initial release.
