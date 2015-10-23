require 'rack'
require 'font_assets/mime_types'

module FontAssets
  class Middleware

    def initialize(app, origin, options={})
      @app = app
      @origin = origin
      @options = options
      @mime_types = FontAssets::MimeTypes.new(Rack::Mime::MIME_TYPES)
    end

    def access_control_headers
      {
        "Access-Control-Allow-Origin" => origin,
        "Access-Control-Allow-Methods" => "GET",
        "Access-Control-Allow-Headers" => "x-requested-with",
        "Access-Control-Max-Age" => "3628800"
      }
    end

    def call(env)
      @path = env["PATH_INFO"]

      if font_asset?
        set_cross_origin_headers(env)
      else
        @app.call(env)
      end
    end


    private

    def set_cross_origin_headers(env)
      @ssl_request = Rack::Request.new(env).ssl?
      # intercept the "preflight" request
      if env["REQUEST_METHOD"] == "OPTIONS"
        return [200, access_control_headers, []]
      else
        code, headers, body = @app.call(env)
        set_headers!(headers, body)
        [code, headers, body]
      end
    end

    def origin
      if !wildcard_origin? and allow_ssl? and ssl_request?
        uri = URI(@origin)
        uri.scheme = "https"
        uri.to_s
      else
        @origin
      end
    end

    def wildcard_origin?
      @origin == '*'
    end

    def ssl_request?
      @ssl_request
    end

    def allow_ssl?
      @options[:allow_ssl]
    end

    def extension
      if @path.nil? || @path.length == 0
        nil
      else
        "." + @path.split("?").first.split(".").last
      end
    end

    def font_asset?
      @mime_types.font? extension
    end

    def set_headers!(headers, body)
      headers.merge!(access_control_headers)
      headers.merge!('Content-Type' => mime_type) if headers['Content-Type']
    end

    def mime_type
      @mime_types[extension]
    end
  end
end
