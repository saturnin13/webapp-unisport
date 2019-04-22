require File.expand_path('../boot', __FILE__)

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Unisport
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    ## Change the schema of the database to be SQL readable
    config.active_record.schema_format = :sql

    ## Automatically load the library path for testing
    config.autoload_paths += %W(#{Rails.root}/lib)

    ## Precompile new manifest files
    config.assets.precompile +=
      [
        "authentification.css",
        "feed.css",
        "feed.js",
        "feedAngular/app.js",
        "feedAngular/controllers.js",
        "feedAngular/directives.js",
        "feedAngular/filters.js",
        "feedAngular/services.js",
        "profile.css",
        "profile.js",
      ]

    config.assets.paths << Rails.root.join("app", "assets", "images", "sports")

    ## Set up the template to use for each controller
    config.to_prepare do
      FeedController.layout                      "feed"
      ProfileController.layout                   "profile"

      Users::SessionsController.layout           "users/sessions"
      Users::RegistrationsController.layout      "users/registrations"
      Users::ConfirmationsController.layout      "users/confirmations"
      Users::UnlocksController.layout            "users/unlocks"
      Users::PasswordsController.layout          "users/passwords"
      Users::OmniauthCallbacksController.layout  "application"
    end

  end
end
