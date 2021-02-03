require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Qna
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    #fallbacks
    config.i18n.fallbacks = true
    #Локаль по умолчанию
    config.i18n.default_locale = :en
    # Permitted locales available for the application
    config.i18n.available_locales = [:ru, :kz, :en]
    #Default time-zona from app
    config.time_zone = 'Almaty'

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.autoload_paths += [config.root.join('app')]

    config.generators do |g|
      g.test_framework :rspec,
                      view_specs: false,
                      helper_specs: false,
                      routng_specs: false,
                      request_specs: false
    end
  end
end
