require 'font_assets/middleware'

module FontAssets
  class Railtie < Rails::Railtie
    config.font_assets = ActiveSupport::OrderedOptions.new

    initializer "font_assets.configure_rails_initialization" do |app|
      config.font_assets.origin ||= "*"

      app.middleware.insert_before 'ActionDispatch::Static', FontAssets::Middleware, config.font_assets.origin
    end
  end
end
