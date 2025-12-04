# app/services/user_importer.rb

class UserImporter
  def self.import_from_spreadsheet
    session = GoogleDrive::Session.from_service_account_key(
      Rails.root.join("config/eighth-facet-468213-h7-9e4a9687aedf.json")
    )

    spreadsheet = session.spreadsheet_by_key("1flsb-aNj-5RxwfVAm5UdgsMnMCmKi4Y5afCghNFmFyo") # 後で差し替え
    worksheet = spreadsheet.worksheets.first

    header = worksheet.rows.first
    (2..worksheet.num_rows).each do |i|
      row = worksheet.rows[i - 1]
      user_data = Hash[header.zip(row)]

      next if User.exists?(email: user_data['email'])

User.create!(
        email: user_data['email'],
        name: user_data['full_name'],
        tel: user_data['phone_number'],
        age: user_data['date_of_birth'],
        nationality: user_data['what_is_your_nationality?（あなたの国籍はどこですか？）'],
        past_business: user_data['_what_job_are_you_currently_doing?（あなたはげんざいなんのしごとをしていますか？）'],
        password: '12345678',
        password_confirmation: '12345678', # ← この行の末尾にカンマが必要です
        past_genre: user_data['what_industry_are[were]_you_in?（あなたはなんのしごとをしていますか？）'],
        past_year: user_data['how_long_years_have_you_been_working_in_japan?（にほんでなんねんかんはたらきましたか？）'],
        qualifications: user_data['tell_us_all_the_qualifications_you_have（あなたがもっているすべてのしかくをかいてください）'],
        work_range: user_data['please_tell_me_your_status_of_residence（visaのしゅるいをおしえてください）'],
        hope_work: user_data['ad_name'],
        #hope_other: user_data['hope_other'],
        #line: user_data['line'],
        period: user_data['_when_are_you_available_to_work?（あなたはいつからはたらけますか？）'],
        #recommend: user_data['recommend'],
        #remarks: user_data['remarks'],
        #conversation: user_data['conversation'],
        #resume: user_data['resume'],
        #available: user_data['available'],
        #different: user_data['different'],
        change_the_address: user_data['can_you_change_the_prefecture_you_live_in?あなたはすむとどふけんをかえることができますか?'],
        call_available: user_data['could_you_tell_me_the_time_you_will_come_out.（電話を出れる時間を教えてください。）'],
        speak_japanese: user_data['can_you_speak_japanese?（あなたはにほんごをはなすことができますか？）'],
        gender: user_data['gender'],
      )
    end
  end
end
