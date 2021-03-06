require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module JfmkAuth
  class Application < Rails::Application
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set up logging to be the same in all environments but control the level
    # through an environment variable.
    config.log_level = ENV.fetch('LOG_LEVEL') {'debug'}

    # Log to STDOUT because Docker expects all processes to log here. You could
    # then redirect logs to a third party service on your own such as systemd,
    # or a third party host such as Loggly, etc..
    # Allow tagged logging. Production env adds tags.
    config.logger = ActiveSupport::TaggedLogging.new ActiveSupport::Logger.new(STDOUT)

    # Enable lograge to compact requests in logs
    config.lograge.enabled = true

    # Action mailer settings.
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      address:              ENV['SMTP_ADDRESS'],
      port:                 ENV['SMTP_PORT'].to_i,
      domain:               ENV['SMTP_DOMAIN'],
      user_name:            ENV['SMTP_USERNAME'],
      password:             ENV['SMTP_PASSWORD'],
      authentication:       ENV['SMTP_AUTH'],
      enable_starttls_auto: ENV['SMTP_ENABLE_STARTTLS_AUTO'] == 'true'
    }

    config.action_mailer.default_url_options = {
      host: ENV['ACTION_MAILER_HOST']
    }
    config.action_mailer.default_options = {
      from: ENV['ACTION_MAILER_DEFAULT_FROM'],
      to: ENV['ACTION_MAILER_DEFAULT_TO']
    }

    # Set Redis as the back-end for the cache.
    # config.cache_store = :redis_store, ENV['REDIS_CACHE_URL']
    config.cache_store = :memory_store, { size: 64.megabytes }

    # Set Sucker Punch as the back-end for Active Job.
    config.active_job.queue_adapter = :sucker_punch
    config.active_job.queue_name_prefix = "#{ENV['ACTIVE_JOB_QUEUE_PREFIX']}_#{Rails.env}"

    # Action Cable setting to de-couple it from the main Rails process.
    #config.action_cable.url = ENV['ACTION_CABLE_FRONTEND_URL']

    # Action Cable setting to allow connections from these domains.
    #origins = ENV['ACTION_CABLE_ALLOWED_REQUEST_ORIGINS'].split(',')
    #origins.map! { |url| /#{url}/ }
    #config.action_cable.allowed_request_origins = origins

    # Gzip responses
    config.middleware.use Rack::Deflater

    # Timezone
    config.time_zone = 'Pacific Time (US & Canada)'
    config.active_record.default_timezone = :local
  end
end
