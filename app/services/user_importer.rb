class UserImporter
  def self.import_from_spreadsheet
    session = GoogleDrive::Session.from_service_account_key(
      Rails.root.join("config/eighth-facet-468213-h7-9e4a9687aedf.json")
    )

    spreadsheet = session.spreadsheet_by_key(
      "1flsb-aNj-5RxwfVAm5UdgsMnMCmKi4Y5afCghNFmFyo"
    )
    worksheet = spreadsheet.worksheets.first

    rows = worksheet.rows
    return if rows.blank?

    header = rows.first
    Rails.logger.info "===== SPS HEADER DUMP START ====="
    Rails.logger.info header.map { |h| [h, h.bytes] }
    Rails.logger.info "===== SPS HEADER DUMP END ====="

    # 列名 → index マッピング
    index = {}
    header.each_with_index do |column_name, i|
      index[column_name] = i
    end

    # データ行処理
    rows.drop(1).each_with_index do |row, row_index|
      next if row.blank?

      begin
        email = row[index['email']]
        next if email.blank?

        # ★ここが変更ポイント（上書き対応）
        user = User.find_or_initialize_by(email: email)

        user.assign_attributes(
          name: row[index['full_name']],
          tel: row[index['phone_number']],
          age: row[index['date_of_birth']],
          address: row[index['city']],

          past_year: row[index['how_long_years_have_you_been_working_in_japan?（にほんでなんねんかんはたらきましたか？）']],
          work_range: row[index['please_tell_me_your_status_of_residence（visaのしゅるいをおしえてください）']],
          hope_work: row[index['ad_name']],
          period: row[index['when_are_you_available_to_work?（あなたはいつからはたらけますか？）']],
          speak_japanese: row[index['can_you_speak_japanese?（あなたはにほんごをはなすことができますか？）']],
          gender: row[index['gender']],

          password: '11111111',
          password_confirmation: '11111111'
        )

        user.save!(validate: false)

        # メール送信
        UserMailer.send_email(user).deliver_now

        # SMS送信
        SendSmsJob.perform_now(user.id)

      rescue => e
        Rails.logger.error <<~LOG
          [UserImporter ERROR]
          Row: #{row_index + 2}
          Error: #{e.class}
          Message: #{e.message}
          Row data: #{row.inspect}
        LOG
        next
      end
    end
  end
end