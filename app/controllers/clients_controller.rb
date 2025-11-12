class ClientsController < ApplicationController
  #before_action :authenticate_admin!, only: [:index, :destroy]  
  #before_action :authenticate_any!, only: [:show]
  def index
    @clients = Client.all
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

  if @client.save
    if params[:commit] == '登録＋商談メール送信'
      # 保存後にメール送信
      ClientMailer.teleapo_send_email(@client).deliver_later
      ClientMailer.teleapo_reply_email(@client).deliver_later
    end
    redirect_to clients_path, notice: "クライアントを登録しました"
  else
    flash.now[:alert] = @client.errors.full_messages.join(", ")
    render :new
  end
end

  def show
  @client = Client.find(params[:id])
  @job = @client.jobs.build # 新規用
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

  private
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
      :remarks
    )
  end
end