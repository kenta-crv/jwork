Rails.application.configure do
  # 1. 基本設定：リクエストごとにコードを再読み込み（開発の基本）
  config.cache_classes = false
  config.eager_load = false

  # 2. エラー表示：開発環境では詳細なエラーを表示する
  config.consider_all_requests_local = true
  config.hosts << "210.131.214.36"
  # 3. キャッシュ設定：tmp/caching-dev.txt があれば有効、なければ無効
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true
    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false
    config.cache_store = :null_store
  end

  # 4. メール設定：ホストをlocalhostに統一（本番ドメインを混ぜない）
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_caching = false
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

  # 5. アセット設定（CSS崩れ・JSエラーの急所）
  # debugをfalseにすることで、ファイルを1本にまとめて読み込み順の事故を防ぐ
  config.assets.debug = false
  config.assets.quiet = true
  
  # プリコンパイルしていなくても、その場でCSS/JSを生成することを許可（必須）
  config.assets.compile = true

  # 6. ホスト設定：開発環境のURLを強制的にlocalhostに向ける
  config.action_controller.default_url_options = { host: 'localhost:3000' }
  Rails.application.routes.default_url_options[:host] = 'localhost:3000'

  # 7. その他
  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker
end