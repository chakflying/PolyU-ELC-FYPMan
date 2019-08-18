# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PolyFYPman
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults "6.0"
    config.active_job.queue_adapter = :delayed_job

    config.time_zone = 'Hong Kong'

    # Sentry Config
    config.filter_parameters << :password
    Raven.configure do |config|
      config.dsn = 'https://a063f08d9aee48d0b35c4cc703162859:716fa77b298b41718b468a95db808a8e@sentry.io/1415213'
      config.environments = %w[production]
      config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
