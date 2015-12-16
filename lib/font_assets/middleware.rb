require 'rack'
require 'font_assets/mime_types'

module FontAssets
  class Middleware
    attr_reader :origin, :options, :mime_types

    def initialize(app, origin, options={})
      @app = app
      @origin = origin
      @options = options
      @mime_types = FontAssets::MimeTypes.new(Rack::Mime::MIME_TYPES)
    end

    def call(env)
      FontAssetsRequest.new(self, env).do_request do
        @app.call(env)
      end
    end

    class FontAssetsRequest
      def initialize(middleware, env)
        @middleware = middleware
        @request = Rack::Request.new(env)
      end

      def do_request
        if font_asset?
          if @request.options?
            return [200, access_control_headers, []]
          else
            code, headers, body = yield

            headers.merge!(access_control_headers)
            headers.merge!('Content-Type' => mime_type) if headers['Content-Type']

            [code, headers, body]
          end
        else
          yield
        end
      end

      private
      def access_control_headers
        {
          "Access-Control-Allow-Origin" => origin,
          "Access-Control-Allow-Methods" => "GET",
          "Access-Control-Allow-Headers" => "x-requested-with",
          "Access-Control-Max-Age" => "3628800"
        }
      end

      def origin
        if !wildcard_origin? and allow_ssl? and ssl_request?
          uri = URI(@middleware.origin)
          uri.scheme = "https"
          uri.to_s
        else
          @middleware.origin
        end
      end

      def wildcard_origin?
        @middleware.origin == '*'
      end

      def ssl_request?
        @request.scheme == "https"
      end

      def allow_ssl?
        @middleware.options[:allow_ssl]
      end

      def path
        @request.path_info
      end

      def font_asset?
        mime_types.font? extension
      end

      def mime_type
        mime_types[extension]
      end

      def mime_types
        @middleware.mime_types
      end

      def extension
        if path.nil? || path.length == 0
          nil
        else
          "." + path.split("?").first.split(".").last
        end
      end
    end
  end
end
