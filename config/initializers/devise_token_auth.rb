DeviseTokenAuth.setup do |config|
  config.token_cost = Rails.env.test? ? 4 : 10

  config.change_headers_on_each_request = false

  config.token_lifespan = 2.weeks

  config.max_number_of_devices = 10

  config.batch_request_buffer_throttle = 5.seconds

  config.enable_standard_devise_support = true
end
