CarrierWave.configure do |config|
  if Rails.env.staging? || Rails.env.production?
    config.fog_credentials = {
          :provider               => 'AWS',                        # required
          :aws_access_key_id      => ENV['AWS_ACCESS_KEY_ID'],                        # required
          :aws_secret_access_key  => ENV['AWS_SECRET_ACCESS_KEY'],                        # required
    }
    config.fog_directory  = ENV['AWS_BUCKET_NAME']                          # required
  else
    config.storage = :file
    config.enable_processing = Rails.env.development?
  end
end
