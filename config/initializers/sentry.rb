# frozen_string_literal: true

Sentry.init do |config|
  config.dsn = ''
  config.breadcrumbs_logger = %i[active_support_logger http_logger]
  # Disable performance monitoring
  config.traces_sample_rate = 0
end
