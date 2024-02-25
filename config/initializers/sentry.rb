Sentry.init do |config|
    config.dsn = 'https://85bfa2d8f5e821b2dc9667d407fcee3d@o4506799250407424.ingest.sentry.io/4506806914449408'
    config.breadcrumbs_logger = [:active_support_logger, :http_logger]
    # Disable performance monitoring
    config.traces_sample_rate = 0
  end