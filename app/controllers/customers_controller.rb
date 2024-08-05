class CustomersController < ApplicationController
  before_action :authenticate_client!, only: [:index, :show]
  def index
    @customers = Customer.order(created_at: "DESC").page(params[:page])
  end

  def show
    @customer = Customer.find_by(id: params[:id])
    @comment = Comment.new
    if @customer
      @offer = @customer.offers.new
    else
      redirect_to customers_path, alert: "Customer not found."
    end
  end

  def new
    @customer = current_client.build_customer
  end

  def confirm
    @customer = current_client.build_customer(customer_params)
    if @customer.invalid?
      render :new
    else
      render :confirm
    end
  end

  def thanks
    @customer = current_client.customer || current_client.build_customer(customer_params)
    if @customer.save
      CustomerMailer.received_email(@customer).deliver
      CustomerMailer.send_email(@customer).deliver
      flash[:notice] = "送信が完了しました。"
      redirect_to root_path
    else
      flash[:alert] = "送信できませんでした。"
      render :confirm
    end
  end

  def create
    @customer = current_client.build_customer(customer_params)
    if @customer.save
      redirect_to customers_confirm_path
    else
      render 'new'
    end
  end

  def edit
    @customer = Customer.find(params[:id])
  end

  def info
    @customer = Customer.find(params[:id])
  end

  def payment
    @customer = Customer.find(params[:id])
  end

  def conclusion
    @customer = Customer.find(params[:id])
    today = Date.today.strftime("%Y-%m-%d")
  end

  def start
    @customer = Customer.find(params[:id])
    today = Date.today.strftime("%Y-%m-%d")
  end

  def calendar
  end

  def destroy
    @customer = Customer.find(params[:id])
    @customer.destroy
    redirect_to customers_path, alert:"削除しました"
  end

  def update
    @customer = Customer.find(params[:id])
  
    if @customer.update(customer_params)
      # conclusion.html.slimからの送信で、かつ同意が得られた場合
      if @customer.agree == "同意しました"
          # メール送信処理
          CustomerMailer.contract_received_email(@customer).deliver_now
          CustomerMailer.contract_send_email(@customer).deliver_now
          flash[:notice] = "契約が完了しました"
          redirect_to info_customer_path(@customer)
        # edit.html.slimからの送信、またはconclusion.html.slimからの送信でも同意が得られなかった場合
      else
        redirect_to info_customer_path(@customer)
      end
    else
      # 更新が失敗した場合の処理
      render :edit
    end
  end

  def send_mail
    @customer = Customer.find(params[:id])
    CustomerMailer.received_first_email(@customer).deliver_now
    CustomerMailer.send_first_email(@customer).deliver_now
    redirect_to info_customer_path(@customer), notice: "#{@customer.company}へ契約依頼のメール送信を行いました。"
  end

  def send_mail_start
    @customer = Customer.find(params[:id])
    CustomerMailer.received_start_email(@customer).deliver_now
    CustomerMailer.send_start_email(@customer).deliver_now
    redirect_to info_customer_path(@customer), notice: "#{@customer.company}へ開始日のメール送信を行いました。"
  end

  private
  def customer_params
    params.require(:customer).permit(
    #問い合わせ項目
    :company, #会社名
    :name, #担当者
    :tel, #電話番号
    :email, #メールアドレス
    :address, #所在地
    :period, #導入希望時期
    :message, #備考
    #自社入力
    :service, #サービス内容
    :contract_period, #契約期間
    :unit_price, #単価
    :maximum_hours, #最大時間数
    :approach_area, #アプローチエリア
    :approach_industry, #アプローチ業種
    #契約情報
    :post_title, #代表取締役
    :president_name, #代表取締役
    :agree, #契約同意
    :contract_date, #契約日
    )
  end
end
