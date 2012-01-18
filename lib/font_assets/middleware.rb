require 'rack'
require 'font_assets/mime_types'

module FontAssets
  class Middleware

    def initialize(app, origin)
      @app = app
      @origin = origin
      @mime_types = FontAssets::MimeTypes.new(Rack::Mime::MIME_TYPES)
    end

    def access_control_headers
      {
        "Access-Control-Allow-Origin" => @origin,
        "Access-Control-Allow-Methods" => "GET",
        "Access-Control-Allow-Headers" => "x-requested-with",
        "Access-Control-Max-Age" => "3628800"
      }
    end

    def call(env)
      # intercept the "preflight" request
      if env["REQUEST_METHOD"] == "OPTIONS"
        return [200, access_control_headers, []]
      else
        code, headers, body = @app.call(env)
        set_headers! headers, body, env["PATH_INFO"]
        [code, headers, body]
      end
    end


    private


    def extension(path)
      "." + path.split("?").first.split(".").last
    end

    def font_asset?(path)
      @mime_types.font? extension(path)
    end

    def set_headers!(headers, body, path)
      if ext = extension(path) and font_asset?(ext)
        headers.merge!(access_control_headers)
        headers.merge!('Content-Type' => mime_type(ext)) unless body.empty?
      end
    end

    def mime_type(extension)
      @mime_types[extension]
    end
  end
end
