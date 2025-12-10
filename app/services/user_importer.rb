# app/services/user_importer.rb

class UserImporter
  def self.import_from_spreadsheet
    require 'google_drive'

    session = GoogleDrive::Session.from_service_account_key(
      Rails.root.join("config/eighth-facet-468213-h7-9e4a9687aedf.json")
    )
    spreadsheet = session.spreadsheet_by_key("1flsb-aNj-5RxwfVAm5UdgsMnMCmKi4Y5afCghNFmFyo")
    worksheet = spreadsheet.worksheets.first

    # header = worksheet.rows.first  # 使わない

    worksheet.list.each do |raw_data|
      # raw_data は "ヘッダー名" => 値 の Hash

      # 必要ならこちらで属性名をマッピングしてください
      attributes = raw_data.transform_keys do |key|
        # 例: スペース除去、小文字化など、好みに応じてキー名をシンボルにするなど
        key.strip.underscore.to_sym rescue key.to_s
      end

      # 必要なら email 重複チェックを外す／残す
      # 例: next if attributes[:email].blank?

      User.create!(
        attributes.slice(
          :id,
          :created_time,
          :ad_id,
          :ad_name,
          :adset_id,
          :adset_name,
          :campaign_id,
          :campaign_name,
          :form_id,
          :form_name,
          :is_organic,
          :platform,
          :"do_you_have_a_driver's_lisence?（うんてんめんきょしょうはもっていますか？）",
          :"please_tell_me_where_you_can_work.（あなたがおしごとできるばしょをせんたくしてください。）",
          :"please_tell_me_your_status_of_residence（visaのしゅるいをおしえてください）",
          :"how_long_years_have_you_been_working_in_japan?（にほんでなんねんかんはたらきましたか？）",
          :"when_are_you_available_to_work?（あなたはいつからはたらけますか？）",
          :"can_you_speak_japanese?（あなたはにほんごをはなすことができますか？）",
          :"after_applying,_be_sure_to_add_us_as_a_friend_on_line.（もうしこみのあと、かならずlineにともだちろうろくしてください）",
          :full_name,
          :date_of_birth,
          :gender,
          :phone_number,
          :email,
          :lead_status,
          :status,
          :remarks
        ).merge(
          password: "12345678",
          password_confirmation: "12345678"
        )
      )
    end
  end
end
