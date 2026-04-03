class UsersController < ApplicationController
def index
  base_q = params[:q]&.to_unsafe_h || {}

  tel_variants = nil

  if base_q["tel_cont"].present?
    tel = base_q["tel_cont"]

    normalized = tel.gsub(/\D/, '')

    variants = []

    if normalized.start_with?('81')
      variants << '0' + normalized[2..]
    elsif normalized.start_with?('0')
      variants << normalized
    end

    if normalized.start_with?('0')
      variants << '81' + normalized[1..]
    else
      variants << normalized
    end

    tel_variants = variants.uniq
    base_q.delete("tel_cont")
  end

  # =========================
  # Ransack
  # =========================
  if base_q["status_eq"] == "sms"
    other_conditions = base_q.except("status_eq")

    @q = User.ransack(
      other_conditions.merge(
        "g" => [
          {
            "m" => "or",
            "status_eq" => "sms",
            "status_null" => true
          }
        ]
      )
    )
  else
    @q = User.ransack(base_q)
  end

  users = @q.result(distinct: true)

  # =========================
  # 電話番号フィルタ（ここが重要）
  # =========================
  if tel_variants.present?
    conditions = tel_variants.map do |v|
      "REPLACE(REPLACE(tel, '+', ''), '-', '') LIKE ?"
    end.join(" OR ")

    values = tel_variants.map { |v| "%#{v}%" }

    users = users.where(conditions, *values)
  end

  @users = users
             .includes(:comments)
             .order(updated_at: :desc)
             .paginate(page: params[:page], per_page: 150)

  @status_interviewed  = base_q["status_eq"] == "interviewed"
  @status_sms_partial = base_q["status_eq"] == "sms"
end

  def new 
    @user = User.new
  end

  def thanks
  end
  
  def show
    @user = User.find(params[:id])
    @comment = Comment.new
  end  

  def edit
    @user = User.find(params[:id])
  end

  def info
    @user = User.find(params[:id])
  end

  def payment
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    previous_agree = @user.agree

    if @user.update(user_params)
      if @user.agree == "Agree" && previous_agree != "Agree"
        UserMailer.contract_received_email(@user).deliver_now
        UserMailer.contract_send_email(@user).deliver_now
        flash[:notice] = "契約が完了しました"
      end

      respond_to do |format|
        format.html { redirect_to(current_admin.present? ? users_path : info_user_path(@user)) }
        format.json { render json: { status: :ok, message: 'Status updated successfully.', new_status: @user.status } }
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.json { render json: { status: :unprocessable_entity, errors: @user.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def conclusion
    @user = User.find(params[:id])
    today = Date.today.strftime("%Y-%m-%d")
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path, alert: "削除しました"
  end

def bulk_sms
  # IDが届いているかログで確認
  Rails.logger.info "--- DEBUG: user_ids = #{params[:user_ids].inspect} ---"
  
  users = User.where(id: params[:user_ids])
  return redirect_to users_path, alert: "ユーザーを選択してください" if users.empty?

  client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])

  users.each do |user|
    next if user.tel.blank?
    begin
      # ★個別送信と同じ整形ロジックを必ず入れる（これがないと本番は 20404 で死ぬ）
      raw_tel = user.tel.to_s.gsub(/[^\d+]/, '')
      to_number = raw_tel.start_with?('0') ? "+81#{raw_tel[1..-1]}" : "+#{raw_tel}"

      client.messages.create(
        from: ENV['TWILIO_PHONE_NUMBER'],
        to: to_number,
        body: "..."
      )
      sleep(0.5)
    rescue => e
      Rails.logger.error "失敗: #{user.id}: #{e.message}"
    end
  end
  redirect_to users_path, notice: "送信完了"
end
  # ==========================================
  # 2. IVR単体発信 (080... を +81... に変換)
  # ==========================================
  def call_ivr
    user = User.find(params[:id])

    if user.tel.blank?
      redirect_to users_path, alert: "電話番号が設定されていません"
      return
    end

    begin
      # 番号整形: 080... -> +8180...
      raw_tel = user.tel.to_s.strip.sub(/^p:/, '').gsub(/[^\d+]/, '')
      
      if raw_tel.match?(/^0\d{9,11}$/)
        to_number = "+81#{raw_tel[1..-1]}"
      elsif raw_tel.match?(/^81\d{9,11}$/)
        to_number = "+#{raw_tel}"
      else
        to_number = raw_tel
      end

      client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])
      ivr_url = "https://j-work.jp/users/#{user.id}/show_ivr"

      client.calls.create(
        from: ENV['TWILIO_PHONE_NUMBER'],
        to: to_number,
        url: ivr_url
      )

      flash[:notice] = "#{user.name} に IVR 発信しました。(To: #{to_number})"
    rescue => e
      flash[:alert] = "IVR 発信に失敗しました: #{e.message}"
    end

    redirect_to users_path
  end

  # ==========================================
  # 3. IVR一括発信 (バックグラウンドJobを起動)
  # ==========================================
  def bulk_call_ivr
    base_q = params[:q]&.to_unsafe_h || {}

    if base_q["status_eq"] == "sms"
      other_conditions = base_q.except("status_eq")
      @q = User.ransack(
        other_conditions.merge(
          "g" => [{ "m" => "or", "status_eq" => "sms", "status_null" => true }]
        )
      )
    else
      @q = User.ransack(base_q)
    end

    users = @q.result

    if users.present?
      users.each_with_index do |user, index|
        # 10秒おきに順次実行。Job側での正規表現修正も忘れずに行ってください。
        CallUserJob.set(wait: (index * 10).seconds).perform_later(user.id)
      end
      flash[:notice] = "#{users.count}人に対して順次IVR発信を開始しました。"
    else
      flash[:alert] = "対象ユーザーが見つかりません。"
    end

    redirect_back(fallback_location: users_path)
  end


  def bulk_sms
  users = User.where(id: params[:user_ids])

  client = Twilio::REST::Client.new(
    ENV['TWILIO_ACCOUNT_SID'],
    ENV['TWILIO_AUTH_TOKEN']
  )

  success_count = 0
  error_count   = 0

  users.each_with_index do |user, index|
    begin
      client.messages.create(
        from: ENV['TWILIO_PHONE_NUMBER'],
        to: user.tel,
        body: "Thank you for applying to the J Work job posting the other day. We will contact you about the job via LINE. Please register here: https://j-work.jp/line"
      )

      success_count += 1

      # ★重要：レート制御（Twilio対策）
      sleep(0.5)

    rescue => e
      Rails.logger.error "SMS送信失敗 user_id=#{user.id}: #{e.message}"
      error_count += 1
    end
  end

  redirect_to users_path,
    notice: "SMS送信: 成功 #{success_count}件 / 失敗 #{error_count}件"
end

  private

  def user_params
    params.require(:user).permit(
      :user_name, :email, :current_password, :password, :password_confirmation,
      :name, :tel, :age, :nationality, :past_business, :past_genre, :past_year, :qualifications,
      :work_range, :hope_work, :hope_other, :line, :period, :recommend, :remarks, :conversation,
      :resume, :available, :different, :call_check, :call_impressions, :change_the_address,
      :call_available, :speak_japanese, :gender, :drivers_lisence, :car, :address, 
      :change_the_address_check, :work_now, :experience, :which_visa, :japanese_level, 
      :visiting_in_japan, :kanzi, :start, :address_detail, :drivers_up, :emergency_name,
      :emergency_relationships, :emergency_tel, :agree, :check_1, :check_2, :check_3, :check_4,
      :check_5, :check_6, :check_7, :deliver, :day_off, :contract_date, :account_name,
      :image_1, :image_2, :image_3, :image_4, :image_5, :image_6, :bank, :branch, :bank_number,
      :bank_name, :status, :next_call_at
    )
  end
end