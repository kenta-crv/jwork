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
        # index[key]がnilの場合にrow[nil]でTypeErrorにならないためのガード
        get_val = ->(key) {
          idx = index[key]
          idx ? row[idx] : nil
        }

        email = get_val.call('email')
        next if email.blank?

        # 上書き対応
        user = User.find_or_initialize_by(email: email)

        user.assign_attributes(
          name:           get_val.call('full_name'),
          tel:            get_val.call('phone_number'),
          age:            get_val.call('date_of_birth'),
          address:        get_val.call('city'),
          past_year:      get_val.call('how_long_years_have_you_been_working_in_japan?（にほんでなんねんかんはたらきましたか？）'),
          work_range:     get_val.call('please_tell_me_your_status_of_residence（visaのしゅるいをおしえてください）'),
          hope_work:      get_val.call('ad_name'),
          period:         get_val.call('when_are_you_available_to_work?（あなたはいつからはたらけますか？）'),
          speak_japanese: get_val.call('can_you_speak_japanese?（あなたはにほんごをはなすことができますか？）'),
          gender:         get_val.call('gender'),

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