class CreateContracts < ActiveRecord::Migration[5.2]
  def change
    create_table :contracts do |t|
      t.string :agree #同意
      t.string :co #会社名
      t.string :president_first  #代表者姓
      t.string :president_last  #代表者名
      t.string :tel #電話番号
      t.string :address #ご住所住所
      t.string :url #会社HP
      t.string :recruit_url #採用ページ
      t.string :work #採用予定職種
      t.string :qualifications #希望資格
      t.string :number #採用予定人数
      t.string :period #希望採用予定日
      t.string :remarks #その他要望
      t.string :person_first  #採用担当姓
      t.string :person_last  #採用担当名
      t.string :email #採用担当メールアドレス
      t.string :cc #採用担当メールアドレス
      t.string :post_title
      t.string :experience
      t.string :recruit_url_2
      t.string :pdf
      t.string :contract_date
      t.string :unit_price
      t.string :refund 
      t.string :payment #支払日
      t.string :salary #給与
      t.string :employment_conditions #採用条件
      t.string :document_screening #書類選考期間
      t.string :conversion #採択率
      t.string :application #申請代行可否
      t.string :driver_licence #ドライバーライセンス
      t.string :housing #住居
      t.string :age
      t.timestamps
    end
  end
end
