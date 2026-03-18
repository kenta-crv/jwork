Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDIS_URL'] }

  # Sidekiq 起動時に全ジョブクラスをロードする
  Rails.application.config.after_initialize do
    Rails.application.eager_load!  # これで app/jobs 以下の全クラスをロード
  end
end