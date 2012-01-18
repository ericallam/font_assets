module FontAssets
  class Middleware

    def initialize(app, origin)
      @app = app
      @origin = origin
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
        headers.merge!(access_control_headers) if font_asset?(env["PATH_INFO"])
        [code, headers, body]
      end
    end

    private

    def extension(path)
      path.split("?").first.split(".").last
    end

    def font_asset?(path)
      %w(woff eot ttf svg).include? extension(path)
    end

  end
  
end
