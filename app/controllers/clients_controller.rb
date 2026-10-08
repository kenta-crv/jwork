class ClientsController < ApplicationController
  before_action :authenticate_client!, only: [:mypage]
  before_action :authorize_client_record!, except: [:mypage]
  def index
    @clients = Client.includes(:recruits, :jobs).order(updated_at: :desc)
  end

  def mypage
    @client = current_client
    @recruits = @client.recruits.order(updated_at: :desc)
  end

  def disclose
    @client = Client.find(params[:id])
    @client.update(disclosure_clicked_at: Time.current)
    # 開示された案件情報を表示するためのロジック
    redirect_to client_path(@client)
  end

  def info
    @client = Client.find(params[:id])  # 例：params[:id]から取得している想定
  end

  def new
    @client = Client.new
  end

  def create
    @client = Client.new(client_params)
    @client.skip_password_validation = true

    if @client.save
      if params[:commit] == '登録＋商談メール送信'
        ClientMailer.teleapo_send_email(@client).deliver_now
        ClientMailer.teleapo_reply_email(@client).deliver_now
      end
      redirect_to clients_path, notice: "クライアントを登録しました"
    else
      flash.now[:alert] = @client.errors.full_messages.join(", ")
      render :new
    end
  end

  def show
    @client = Client.includes(:recruits, :jobs, :situations).find(params[:id])
    @job = Job.new # 新規用
    @situation = Situation.new
  end

  def edit
    @client = Client.find(params[:id])
  end

  def update
    @client = Client.find(params[:id])

    if @client.update(client_params)
      # conclusion.html.slimからの送信で、かつ同意が得られた場合
      #if @client.agree == "同意しました"
          # メール送信処理
      #    ClientMailer.contract_received_email(@client).deliver_now
      #    ClientMailer.contract_send_email(@client).deliver_now
      #    flash[:notice] = "契約が完了しました"
      #    redirect_to client_path(@client)
        # edit.html.slimからの送信、またはconclusion.html.slimからの送信でも同意が得られなかった場合
      #else
      #  redirect_to client_path(@client)
      #end
    else
      # 更新が失敗した場合の処理
      render :edit
    end
  end

  def conclusion
    @client = Client.find(params[:id])
    today = Date.today.strftime("%Y-%m-%d")
  end

  def destroy
    @client = Client.find(params[:id])
    @client.destroy
    redirect_to clients_url, notice: 'クライアントが削除されました。'
  end

  def send_mail
    @client = Client.find(params[:id])
    ClientMailer.received_first_email(@client).deliver_now
    ClientMailer.send_first_email(@client).deliver_now
    redirect_to info_client_path(@client), notice: "#{@client.company}へ契約依頼のメール送信を行いました。"
  end

  def send_mail_start
    @client = Client.find(params[:id])
    ClientMailer.received_start_email(@client).deliver_now
    ClientMailer.send_start_email(@client).deliver_now
    redirect_to info_client_path(@client), notice: "#{@client.company}へ開始日のメール送信を行いました。"
  end

  def send_portal_invite
    unless admin_signed_in?
      redirect_to new_admin_session_path, alert: "権限がありません"
      return
    end

    @client = Client.find(params[:id])
    if @client.email.blank?
      redirect_to client_path(@client), alert: "メールアドレスが未登録です"
      return
    end

    @client.send_portal_setup_instructions!
    redirect_to client_path(@client), notice: "#{@client.company}へ、マイページ用のパスワード設定案内を送信しました"
  end

  private

  def authorize_client_record!
    return if admin_signed_in?

    if client_signed_in?
      if action_name == "show" && params[:id].to_i == current_client.id
        redirect_to client_mypage_path
      else
        redirect_to client_mypage_path, alert: "権限がありません"
      end
      return
    end

    if action_name == "show"
      redirect_to new_client_session_path, alert: "ログインが必要です"
    else
      redirect_to new_admin_session_path, alert: "ログインが必要です"
    end
  end

  # client または admin のどちらかでログインしていればOK
  def authenticate_any!
    unless client_signed_in? || admin_signed_in?
      redirect_to new_client_session_path, alert: "ログインが必要です"
    end
  end

  def client_params
    params.require(:client).permit(
      :company,
      :position,
      :person,
      :tel,
      :email,
      :mobile,
      :address,
      :url,
      :meeting,
      :remarks,
      :industry
    )
  end
end
