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
      # 前後の空白を削除してマッチング精度を上げる
      index[column_name.to_s.strip] = i
    end

    # データ行処理
    rows.drop(1).each_with_index do |row, row_index|
      next if row.blank?

      begin
        # ★最重要：列が存在しない場合に row[nil] でクラッシュするのを防ぐ
        email_idx = index['email']
        next if email_idx.nil? || row[email_idx].blank?
        
        email = row[email_idx].to_s.strip.downcase

        # 上書き対応
        user = User.find_or_initialize_by(email: email)

        # 各項目について、indexがnil（列が存在しない）場合はnilを代入するようにガード
        user.assign_attributes(
          name:           (i = index['full_name']) ? row[i] : nil,
          tel:            (i = index['phone_number']) ? row[i] : nil,
          age:            (i = index['date_of_birth']) ? row[i] : nil,
          address:        (i = index['city']) ? row[i] : nil,
          past_year:      (i = index['how_long_years_have_you_been_working_in_japan?（にほんでなんねんかんはたらきましたか？）']) ? row[i] : nil,
          work_range:     (i = index['please_tell_me_your_status_of_residence（visaのしゅるいをおしえてください）']) ? row[i] : nil,
          hope_work:      (i = index['ad_name']) ? row[i] : nil,
          period:         (i = index['when_are_you_available_to_work?（あなたはいつからはたらけますか？）']) ? row[i] : nil,
          speak_japanese: (i = index['can_you_speak_japanese?（あなたはにほんごをはなすことができますか？）']) ? row[i] : nil,
          gender:         (i = index['gender']) ? row[i] : nil,

          password: '11111111',
          password_confirmation: '11111111'
        )

        # バリデーションを無視して保存
        user.save!(validate: false)

        # メール送信
        UserMailer.send_email(user).deliver_now

        # SMS送信
        SendSmsJob.perform_now(user.id)

      rescue => e
        # ここで発生した TypeError (row[nil]) などをキャッチしログに残す
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