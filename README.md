Font Assets
=============

This little gem helps serve font-face assets in Rails 3.1.  It really does these two things:

 * Registers font Mime Types for woff, eot, tff, and svg font files
 * Sets Access-Control-Allow-Origin response headers for font assets, which Firefox requires for cross domain fonts

Install
-------

Add `font_assets` to your Gemfile:

    gem 'font_assets'


Usage
-----

Set the origin domain that will get set in the `Access-Control-Allow-Origin` header

    # in config/environments/production.rb

    config.font_assets.origin = 'http://codeschool.com'

The origin domain must match the domain of the site serving the page that is requesting the font, not the host of the font.  For example, if you are using a CDN to serve your assets (like CloudFront), and the full path to the font asset is `http://d3rd6rvl24noqd.cloudfront.net/assets/fonts/Pacifico-webfont-734f1436e605566ae2f1c132905e28b2.woff`, but the URI the user is visiting is `http://coffeescript.codeschool.com/level/1`, you'd want to set the origin header to this:

    config.font_assets.origin = 'http://coffeescript.codeschool.com'


License
-------

Font Assets is released under the MIT license.
