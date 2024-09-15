class ClientsController < ApplicationController
  def index
    @clients = Client.all
  end

  def show
    if user_signed_in? && params[:user_id].present?
      @user = User.find(params[:user_id])
    end
    @client = Client.find(params[:id])
  end

  def edit
    #@client = current_client
    @client = Client.find(params[:id])
  end

  def update
    @client = current_client
    if @client.update(client_params)
      ClientMailer.received_email(@client).deliver
      ClientMailer.send_email(@client).deliver
      redirect_to @client, notice: 'プロフィールが更新されました'
    else
      render :edit
    end
  end

  def info
    @client = Client.find(params[:id])
  end

  def payment
    @client = Client.find(params[:id])
  end

  def conclusion
    @client = Client.find(params[:id])
    today = Date.today.strftime("%Y-%m-%d")
  end

  def destroy
    @client = Client.find(params[:id])
    @client.destroy
    redirect_to clients_path, alert:"削除しました"
  end

  private

  def client_params
    params.require(:client).permit(:client_name, :email, :current_password, :password, :password_confirmation,
    :company, #会社名
    :name, #担当者
    :tel, #電話番号
    :email, #メールアドレス
    :address, #所在地
    :period, #導入希望時期
    #自社入力
    :business, #募集業種
    :genre, #募集業種
    :salary, #給料
    :period, #採用希望
    :remarks, #備考
    #契約情報
    :post_title, #代表取締役
    :president_name, #代表取締役
    :agree,#契約同意
    :contract_date, #契約日
    )
  end
end