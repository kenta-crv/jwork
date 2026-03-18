Sidekiq.configure_server do |config|
  # namespace を 'jwork' に指定して、tcareproと場所を分ける
  config.redis = { url: 'redis://localhost:6379/0', namespace: 'jwork' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://localhost:6379/0', namespace: 'jwork' }
end