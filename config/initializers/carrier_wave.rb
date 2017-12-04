require 'carrierwave/orm/activerecord'

CarrierWave.configure do |config|
  if Rails.env.test?
    config.storage = :file
  else
    config.fog_provider = 'fog/aws'
    config.fog_credentials = {
      provider:          	'AWS',
      aws_access_key_id: 	ENV['AWS_ACCESS_KEY'],
      aws_secret_access_key: ENV['AWS_SECRET_KEY'],
      region:            	ENV['AWS_REGION'],
      host:              	ENV['AWS_HOST'],
      endpoint:          	'https://' + ENV['AWS_HOST'].to_s
    }

    config.fog_directory = ENV['AWS_BUCKET_NAME']
    config.fog_public	= true
  end
end
