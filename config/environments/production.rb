Myflix::Application.configure do

  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  config.serve_static_assets = false

  config.assets.compress = true
  config.assets.js_compressor = :uglifier

  config.assets.compile = false

  config.assets.digest = true

  config.i18n.fallbacks = true

  config.active_support.deprecation = :notify

  config.action_mailer.default_url_options = { :host => ENV['APP_HOST'] }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :address                     => ENV["mailgun_address"]
    :port                        => 587,
    :domain                      => ENV["mailgun_domain"],
    :user_name                   => ENV["mailgun_username"],
    :password                    => ENV["mailgun_password"],
    :authentication              => 'plain',
    :enable_starttls_auto        => true
  }
end
