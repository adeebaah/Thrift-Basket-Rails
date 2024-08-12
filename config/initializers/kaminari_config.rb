Kaminari.configure do |config|
  config.window = 1
  config.page_method_name = :page
  config.default_per_page = 8
  config.window = 4
  config.outer_window = 0
  config.left = 0
  config.right = 0
  config.param_name = :page
  config.params_on_first_page = false
end
