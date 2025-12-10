# app/services/user_importer.rb

class UserImporter
  def self.import_from_spreadsheet
    require 'google_drive'

    session = GoogleDrive::Session.from_service_account_key(
      Rails.root.join("config/eighth-facet-468213-h7-9e4a9687aedf.json")
    )

    spreadsheet = session.spreadsheet_by_key("1flsb-aNj-5RxwfVAm5UdgsMnMCmKi4Y5afCghNFmFyo")
    worksheet = spreadsheet.worksheets.first

    header = worksheet.rows.first

    (2..worksheet.num_rows).each do |i|
      row = worksheet.rows[i - 1]
      raw_data = Hash[header.zip(row)]

      # ここでスプレッドシートの日本語ヘッダー → Rails の英語キーへ変換
      user_data = {
        email: raw_data['メール'],
        name: raw_data['名前'],
        tel: raw_data['電話番号'],
        age: raw_data['生年月日'],
        nationality: raw_data['国籍'],
        past_business: raw_data['現在のお仕事'],
        past_genre: raw_data['職種'],
        past_year: raw_data['日本での就労年数'],
        qualifications: raw_data['資格'],
        work_range: raw_data['在留資格'],
        hope_work: raw_data['応募職種'],
        period: raw_data['就業開始日'],
        change_the_address: raw_data['住所変更可否'],
        call_available: raw_data['電話可能時間'],
        speak_japanese: raw_data['日本語能力'],
        gender: raw_data['性別']
      }

      # ★★★ ここを削除：skip しない ★★★
      # next if User.exists?(email: user_data[:email])

      User.create!(
        **user_data,
        password: "12345678",
        password_confirmation: "12345678"
      )
    end
  end
end
