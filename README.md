Font Assets
=============

This little gem helps serve font-face assets in Rails 3.1.  It really does these
two things:

* Responds with "proper" mime types for woff, eot, tff, and svg font files, and
* Sets Access-Control-Allow-Origin response headers for font assets, which Firefox requires for cross domain fonts.

In addition, it will also respond to the pre-flight OPTIONS requests made by
supporting browsers (Firefox).

Install
-------

Add `font_assets` to your Gemfile:

```ruby
gem 'font_assets'
```


Usage
-----

By default, in a Rails application, this gem should Just Work™.  However, the
default settings allow any requesting site to use the linked fonts, due to the
Allowed Origin being '*', by default.  This is only useful for browsers which
support this feature (Firefox), but restricting it to certain domains may be
beneficial.

Set the origin domain that will get set in the `Access-Control-Allow-Origin`
header:

```ruby
# in config/environments/production.rb
config.font_assets.origin = 'http://codeschool.com'
```

The origin domain must match the domain of the site serving the page that is
requesting the font, not the host of the font.  For example, if you are using a
CDN to serve your assets (like CloudFront), and the full path to the font asset
is `http://d3rd6rvl24noqd.cloudfront.net/assets/fonts/Pacifico-webfont-734f1436e605566ae2f1c132905e28b2.woff`,
but the URI the user is visiting is `http://coffeescript.codeschool.com/level/1`,
you'd want to set the origin header to this:

```ruby
config.font_assets.origin = 'http://coffeescript.codeschool.com'
```

To match the actual `Origin` value, omit the trailing slash
([details](http://dev.opera.com/articles/view/dom-access-control-using-cross-origin-resource-sharing/#AccessControlAllowOrigin)).

An Example Response
-------------------

Below is an example response for a .woff font asset on a Rails 3.1 application
running behind several proxies and caches (including CloudFront):

```
$ curl -i http://d1tijy5l7mg5kk.cloudfront.net/assets/ubuntu/Ubuntu-Bold-webfont-4bcb5239bfd34be67bc07901959fc6e1.woff
HTTP/1.0 200 OK
Server: nginx
Date: Sat, 14 Jan 2012 19:45:19 GMT
Content-Type: application/x-font-woff
Last-Modified: Sat, 14 Jan 2012 16:58:14 GMT
Cache-Control: public, max-age=31557600
Access-Control-Allow-Origin: http://www.codeschool.com
Access-Control-Allow-Methods: GET
Access-Control-Allow-Headers: x-requested-with
Access-Control-Max-Age: 3628800
X-Content-Digest: 66049433125f563329c4178848643536f76459e5
X-Rack-Cache: fresh
Content-Length: 17440
X-Varnish: 311344447
Age: 289983
X-Cache: Hit from cloudfront
X-Amz-Cf-Id: 9yzifs_hIQF_MxPLwSR8zck3eZVXJ8LFKpMUpXnu2SmMuEmyrUbHdQ==,Lbh9kfjr0YRm77seSmOSQ6oFkUEMabvtFStJLhTOy9BfGrIXVneoKQ==
Via: 1.1 varnish, 1.0 2815dd16e8c2a0074b81a6148bd8aa3a.cloudfront.net:11180 (CloudFront), 1.0 f9e7403ca14431787835521769ace98a.cloudfront.net:11180 (CloudFront)
Connection: close
```

In it, you can see where this middleware has injected the `Content-Type` and
`Access-Control-*` headers into the response.

And below is an example OPTIONS request response:

```
$ curl -i -X OPTIONS http://www.codeschool.com/
HTTP/1.1 200 OK
Server: nginx
Date: Wed, 18 Jan 2012 04:13:25 GMT
Connection: keep-alive
Access-Control-Allow-Origin: http://www.codeschool.com
Access-Control-Allow-Methods: GET
Access-Control-Allow-Headers: x-requested-with
Access-Control-Max-Age: 3628800
Vary: Accept-Encoding
X-Rack-Cache: invalidate, pass
Content-Length: 0
```

License
-------

Font Assets is released under the MIT license.

Contributors
------------

* [Nathanial Bibler](https://github.com/nbibler)
* [Eric Allam](https://github.com/rubymaverick)
* [Ryan Montgomery](https://github.com/rmontgomery429)
* [Jack Foy](https://github.com/jfoy)
* [Nick Urban](https://github.com/nickurban)
