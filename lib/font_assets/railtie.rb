require 'font_assets/middleware'

module FontAssets
  class Railtie < Rails::Railtie
    config.font_assets = ActiveSupport::OrderedOptions.new

    initializer "font_assets.configure_rails_initialization" do |app|
      config.font_assets.origin ||= "*"
      config.font_assets.options ||= { allow_ssl: true }

      middleware_operations = app.middleware.instance_variable_get(:@operations)
      insert_target = if defined?(ActionDispatch::Static) && middleware_operations.flatten.include?('ActionDispatch::Static')
        'ActionDispatch::Static'
      else
        'Rack::Runtime'
      end

      app.middleware.insert_before insert_target, FontAssets::Middleware, config.font_assets.origin, config.font_assets.options
    end
  end
end
