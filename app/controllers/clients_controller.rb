class ClientsController < ApplicationController
  #before_action :check_client
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
  @client.password = Devise.friendly_token.first(8)

  if @client.save
    # 管理者が登録していない場合のみメール送信
    unless admin_signed_in?
      ClientMailer.inquiry_send_email(@client).deliver_now
      ClientMailer.inquiry_received_email(@client).deliver_now
    end

    redirect_to thanks_clients_path
  else
    if Client.exists?(email: @client.email)
      redirect_to thanks_clients_path
    else
      render :new
    end
  end
end
  
  def thanks
  end

  def show
    @client = Client.find(params[:id])
    #@estimates = current_client.estimates
  end

  def edit
    @client = Client.find(params[:id])
  end

  #def update
  #  @client = Client.find(params[:id])
  #  if @client.update(client_params)
  #    redirect_to @client, notice: 'クライアント情報が更新されました。'
  #  else
  #    render :edit
  #  end
  #end

  def update
    @client = Client.find(params[:id])
  
    if @client.update(client_params)
      # conclusion.html.slimからの送信で、かつ同意が得られた場合
      if @client.agree == "同意しました"
          # メール送信処理
          ClientMailer.contract_received_email(@client).deliver_now
          ClientMailer.contract_send_email(@client).deliver_now
          flash[:notice] = "契約が完了しました"
          redirect_to client_path(@client)
        # edit.html.slimからの送信、またはconclusion.html.slimからの送信でも同意が得られなかった場合
      else
        redirect_to client_path(@client)
      end
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

  def client_params
    params.require(:client).permit(
      :client_name, :email, :current_password, :password, :password_confirmation,
      :company, :post_title, :representative_name, :contact_name, :tel, :address, :url,
      :message, :agree, :contract_date, :question_people, :question_attractive, :question_open,
      :question_prediction, :agree_1, :agree_2, :agree_3, :agree_4, :agree_5, :agree_6, :agree_7,
      :user_name, :select, :recruit_url, :visa, :business, :genre, :salary, :work_time,
      :day_off, :work_contents, :number, :house_agents, :house_support, :remarks
    )
  end
end