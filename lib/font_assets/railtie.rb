require 'font_assets/middleware'

module FontAssets
  class Railtie < Rails::Railtie
    config.font_assets = ActiveSupport::OrderedOptions.new

    initializer "font_assets.configure_rails_initialization" do |app|
      config.font_assets.origin ||= "*"

      app.middleware.insert_before 'ActionDispatch::Static', FontAssets::Middleware, config.font_assets.origin
    end

    config.after_initialize do
      Rack::Mime::MIME_TYPES['.woff'] ||= 'application/x-font-woff'
      Rack::Mime::MIME_TYPES['.ttf']  ||= 'application/x-font-ttf'
      Rack::Mime::MIME_TYPES['.eot']  ||= 'application/vnd.ms-fontobject'
      Rack::Mime::MIME_TYPES['.svg']  ||= 'image/svg+xml'
    end
  end
end
