require 'font_assets/middleware'

module FontAssets
  class Railtie < Rails::Railtie
    config.font_assets = ActiveSupport::OrderedOptions.new

    initializer "font_assets.configure_rails_initialization" do |app|
      config.font_assets.origin ||= "*"

      app.middleware.insert_before 'ActionDispatch::Static', FontAssets::Middleware, config.font_assets.origin
    end

    config.after_initialize do
      Rack::Mime::MIME_TYPES.merge! '.woff' => 'application/x-font-woff'
      Rack::Mime::MIME_TYPES.merge! '.ttf' => 'application/x-font-ttf'
      Rack::Mime::MIME_TYPES.merge! '.eot' => 'application/vnd.ms-fontobject'
      Rack::Mime::MIME_TYPES.merge! '.svg' => 'image/svg+xml'
    end
  end
end
