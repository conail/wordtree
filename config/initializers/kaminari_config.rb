Kaminari.configure do |config|
  config.default_per_page = 30
  config.window = 8
  config.outer_window = 4
  config.left = 0
  config.right = 0
  config.param_name = :page
end
