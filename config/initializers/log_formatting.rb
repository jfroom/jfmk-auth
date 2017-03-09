class ActiveSupport::Logger::SimpleFormatter
  SEVERITY_TO_COLOR_MAP   = {'DEBUG'=>'0;37', 'INFO'=>'32', 'WARN'=>'33', 'ERROR'=>'31', 'FATAL'=>'31', 'UNKNOWN'=>'37'}

  def call(severity, time, progname, msg)
    formatted_severity = sprintf("%-5s",severity)

    if Rails.env.development?
      color = SEVERITY_TO_COLOR_MAP[severity]
      formatted_time = time.strftime("%Y-%m-%d %H:%M:%S.") << time.usec.to_s[0..2].rjust(3)
      "\033[0;37m#{formatted_time}\033[0m [\033[#{color}m#{formatted_severity}\033[0m] -- #{msg.strip} (pid:#{$$})\n"
    else
      # Don't add time time staging/prod - that happens already with other services.
      # Color doesn't work, just adds noise.
      "#{formatted_severity} -- #{msg.strip} (pid:#{$$})\n"
    end
  end
end

module JfmkAuth
  class Application < Rails::Application
    # Set up logging to be the same in all environments but control the level
    # through an environment variable.
    config.log_level = ENV.fetch('LOG_LEVEL') {'debug'}

    # Log to STDOUT because Docker expects all processes to log here. You could
    # then redirect logs to a third party service on your own such as systemd,
    # or a third party host such as Loggly, etc..
    # Allow tagged logging. Production env adds tags.
    config.logger = ActiveSupport::TaggedLogging.new ActiveSupport::Logger.new(STDOUT)

    # Use Ruby logger for more verbose messages. But not for test - too noisy.
    #config.logger.formatter = ::Logger::Formatter.new unless Rails.env.test?
    config.logger.info 'Test. Logger initialized!'
    config.logger.tagged('config/application') { config.logger.error('Testing logger.error -  not a real error.') }

    # Enable lograge to compact requests in logs
    config.lograge.enabled = true
  end
end
