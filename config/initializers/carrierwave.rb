CarrierWave.configure do |config|
  config.fog_credentials = {
    provider:              'AWS',
    aws_access_key_id:     ENV['AMAZON_ACCESS_KEY_ID'],
    aws_secret_access_key: ENV['AMAZON_SECRET_ACCESS_KEY'],
    region:                ENV['S3_REGION']
  }

  # Set custom options such as cache control to leverage browser caching
  config.fog_attributes = {
    expires: 1.week.from_now.httpdate,
    cache_control: 'max-age=604800'
  }

  if Rails.env.test?
    config.storage = :file
    config.enable_processing = false
    config.fog_directory  = File.join(Rails.root, '/public')
    config.asset_host = File.join(Rails.root, '/public')
  else
    config.storage = :fog
    config.fog_directory  = ENV['S3_BUCKET']
    config.asset_host = ENV['S3_CDN']
  end
end
