require File.expand_path('../boot', __FILE__)

require 'rails/all'

ENV["RAILS_ASSET_ID"] = "" # disable timestamps at end of asset files for offline browsing

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

module OfflineWebApp
  class Application < Rails::Application
    # Added by the Rails 3 jQuery Template
    # http://github.com/lleger/Rails-3-jQuery, written by Logan Leger
    # config.action_view.javascript_expansions[:defaults] = %w(jquery rails jquery-ui.min jquery.ui.datepicker-pt-BR application)
    # config.action_view.javascript_expansions[:cdn]      = %w(https://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js rails)

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(#{config.root}/lib)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Brasilia'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :en

    # config.generators do |g|
    #   g.template_engine     :haml
    #   g.test_framework      :rspec
    #   g.fixture_replacement :factory_girl
    # end

    # JavaScript files you want as :defaults (application.js is always included).
    # config.action_view.javascript_expansions[:defaults] = %w(jquery rails)

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password, :password_confirmation]

    ActiveRecord::Base.include_root_in_json = false
  end
end
