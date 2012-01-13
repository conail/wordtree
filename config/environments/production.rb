Wordtree::Application.configure do
  config.cache_classes = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.serve_static_assets = false
  config.assets.compress = true
  config.assets.compile = false
  config.assets.digest = true

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.

  # See everything in the log (default is :info)

  # Use a different logger for distributed setups

  # Use a different cache store in production

  # Enable serving of images, stylesheets, and JavaScripts from an asset server

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)

  # Disable delivery errors, bad email addresses will be ignored

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  config.active_support.deprecation = :notify
end
