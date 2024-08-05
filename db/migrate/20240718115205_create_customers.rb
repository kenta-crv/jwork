class CreateCustomers < ActiveRecord::Migration[5.2]
  def change
    create_table :customers do |t|
      #問い合わせ項目
      t.string :company #会社名
      t.string :name #担当者
      t.string :tel #電話番号
      t.string :email #メールアドレス
      t.string :address #所在地
      t.string :period #導入希望時期
      t.string :message #備考
      #自社入力
      t.string :service #サービス内容
      t.string :contract_period #契約期間
      t.string :unit_price #単価
      t.string :maximum_hours #最大時間数
      t.string :approach_area #アプローチエリア
      t.string :approach_industry #アプローチ業種
      #契約情報
      t.string :post_title #代表取締役
      t.string :president_name #代表取締役
      t.string :agree #契約同意
      t.string :contract_date #契約日
      t.references :client, foreign_key: true

      t.timestamps
    end
  end
end
