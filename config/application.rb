require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module QnA
  class Application < Rails::Application
    config.load_defaults 6.1
    config.time_zone = 'Moscow'
    config.i18n.default_locale = :ru
    config.active_storage.replace_on_assign_to_many = false

    config.action_cable.disable_request_forgery_protection = false

    config.generators do |g|
      g.test_framework :rspec,
                       view_specs: false,
                       helper_specs: false,
                       routing_specs: false,
                       request_specs: false
    end
  end
end
