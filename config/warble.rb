# START:basic
Warbler::Config.new do |config|
  # START:features
  config.features = %w(executable)
  # END:features
  config.jar_name = "stock-service"
  # END:basic
  # START:async
  config.webxml.servlet_filter_async = true
  # END:async
  # START:basic
end
#END:basic
