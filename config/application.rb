# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'
require 'dotenv/load' unless Rails.env.production?

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module FriendlyFunicular
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.paths.add 'lib', eager_load: true
    config.paths.add 'recruitment/lib', eager_load: true
  end
end
