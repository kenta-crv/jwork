class UsersController < ApplicationController
def index
  base_q = params[:q]&.to_unsafe_h || {}

  if base_q["status_eq"] == "sms"
    @q = User.ransack(
      {
        "m" => "or",
        "status_eq" => "sms",
        "status_null" => true
      }.merge(base_q.except("status_eq"))
    )
  else
    @q = User.ransack(base_q)
  end

  @users = @q.result(distinct: true)
             .includes(:comments)
             .order(updated_at: :desc)
             .paginate(page: params[:page], per_page: 150)

  @status_interviewed_driver  = base_q["status_eq"] == "interviewed" && base_q["hope_work_eq"] == "Driver"
  @status_interviewed_cleaner = base_q["status_eq"] == "interviewed" && base_q["hope_work_eq"] == "Cleaner"
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

  def send_sms
    user = User.find(params[:id])
    
    if user.tel.present?
      begin
        client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])
        message_body = "Interviews are conducted on LINE. Please register here: https://j-work.jp/line\n面接はLINEで行います。こちらから登録してください: https://j-work.jp/line"
        
        to_number = user.tel.sub(/^p:/, '')
        client.messages.create(
          from: ENV['TWILIO_PHONE_NUMBER'],
          to: to_number,
          body: message_body
        )

        flash[:notice] = "#{user.name} に SMS を送信しました。"
      rescue => e
        flash[:alert] = "SMS送信に失敗しました: #{e.message}"
      end
    else
      flash[:alert] = "電話番号が設定されていません"
    end

    redirect_to users_path
  end

def call_ivr
    user = User.find(params[:id])

    if user.tel.blank?
      redirect_to users_path, alert: "電話番号が設定されていません"
      return
    end

    begin
      client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])

      # ★修正ポイント：環境に依存せず、常に本番ドメインの show_ivr パスを指定します
      ivr_url = "https://j-work.jp/users/#{user.id}/show_ivr"

      to_number = user.tel.sub(/^p:/, '')
      client.calls.create(
        from: ENV['TWILIO_PHONE_NUMBER'],
        to: to_number,
        url: ivr_url
      )

      flash[:notice] = "#{user.name} に IVR 発信しました。"
    rescue => e
      flash[:alert] = "IVR 発信に失敗しました: #{e.message}"
    end

    redirect_to users_path
  end

  def bulk_call_ivr
    @q = User.ransack(params[:q])
    users = @q.result

    if users.present?
      users.each_with_index do |user, index|
        CallUserJob.set(wait: (index * 10).seconds).perform_later(user.id)
      end
      flash[:notice] = "#{users.count}人に対して順次IVR発信を開始しました。"
    else
      flash[:alert] = "対象ユーザーが見つかりません。"
    end

    redirect_back(fallback_location: users_path)
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
      :bank_name, :status
    )
  end
end