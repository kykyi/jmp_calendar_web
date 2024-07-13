

Sentry.init do |config|
  config.dsn = ENV.fetch('SENTRY_DSN', '')
  config.breadcrumbs_logger = %i[active_support_logger http_logger]
  # Disable performance monitoring
  config.traces_sample_rate = 0.1
end
