Sidekiq.configure_server do |config|
  # namespace を消して、末尾を /1 にする
  config.redis = { url: 'redis://localhost:6379/1' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://localhost:6379/1' }
end