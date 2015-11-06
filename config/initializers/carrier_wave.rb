CarrierWave.configure do |config|
  # config.storage = :fog
  # config.fog_credentials = {
  #     :provider               => 'AWS',
  #     :aws_access_key_id      => ENV['AWS_ACCESS'],
  #     :aws_secret_access_key  => ENV['AWS_SECRET'],
  # }
  # if Rails.env.staging? || Rails.env.production?
  #   config.fog_directory  = 'coreycodes-myflix'
  # else
  #   config.fog_directory  = 'coreycodes-myflix-development'
  # end
end
