class OffersController < ApplicationController
  before_action :authenticate_user_or_client!
  before_action :set_user_or_client_and_associated, only: [:new_customer, :create_customer] #from user to customer
  before_action :set_client_or_user_and_associated, only: [:new_worker, :create_worker] #from client to worker

  def index 
    @offers = Offer.all
  end  

  def show
    @offer = Offer.find(params[:id])
  end

  def new
   if user_signed_in? 
    @customer = Customer.find(params[:customer_id])
    @offer = @customer.offers.new
   elsif client_signed_in?
    @worker = Worker.find(params[:worker_id])
    @offer = @worker.offers.new
   else
    redirect_to root_path, alert: "ログインが確認出来ませんでした。"
   end
  end

  def create_customer
   if user_signed_in?
    @customer = Customer.find(params[:offer][:customer_id]) # customer_id をパラメータから取得
    @offer = @customer.offers.new(offer_params)
    @user = User.find_by(id: params[:offer][:user_id])
    @worker = Worker.find_by(id: params[:offer][:worker_id])
    if @user.nil?
      redirect_to new_customer_offer_path(@customer), alert: "User not found."
      return
    end
    if @worker.nil?
      redirect_to new_customer_offer_path(@customer), alert: "Worker not found."
      return
    end
    @offer.user = @user
    @offer.worker = @worker
    if @offer.save
      redirect_to confirm_customer_offer_path(customer_id: @customer.id, id: @offer.id)
    else
      render :new
    end
   elsif client_signed_in?
    @worker = Worker.find(params[:offer][:worker_id]) # worker_id をパラメータから取得
    @offer = @worker.offers.new(offer_params)
    @client = Client.find_by(id: params[:offer][:client_id])
    @customer = Customer.find_by(id: params[:offer][:customer_id])
    if @client.nil?
      redirect_to new_worker_offer_path(@worker), alert: "User not found."
      return
    end
    if @user.nil?
      redirect_to new_worker_offer_path(@worker), alert: "Worker not found."
      return
    end
    @offer.client = @client
    @offer.customer = @wcustomer
    if @offer.save
      redirect_to confirm_worker_offer_path(worker_id: @worker.id, id: @offer.id)
    else
      render :new
    end
   else
    redirect_to root_path, alert: "ログインが確認出来ませんでした。"
   end
  end

  def confirm
    @offer = Offer.find(params[:id])
  end

  def thanks
    @offer = Offer.find(params[:id])
    if @offer.update(confirmed: true) # 確認済みとしてマークするカラムがあれば
      flash[:notice] = "打診が完了しました。マッチングがありましたらご連絡が入ります。"
      redirect_to customers_path
    else
      flash[:alert] = "登録が完了できませんでした。"
      redirect_to new_offer_path
    end
  end

    # PATCH/PUT /offers/1
    def update
      if @offer.update(offer_params)
        redirect_to @offer, notice: 'Offer was successfully updated.'
      else
        render :edit
      end
    end
  
    # DELETE /offers/1
    def destroy
      @offer.destroy
      redirect_to offers_url, notice: 'Offer was successfully destroyed.'
    end
  
    private

    def authenticate_user_or_client!
      unless current_user || current_client
        redirect_to new_user_session_path, alert: "ログインしてください。"
      end
    end
  
    def set_user_or_client_and_associated
      if current_user
        @user = current_user
        @worker = @user.worker
      elsif current_client
        @client = current_client
        @worker = @user.worker
      end
    end

    def set_client_or_user_and_associated
      if current_client
        @client = current_client
        @customer = @client.customer
      elsif current_user
        @user = current_user
        @customer = @client.customer
      end
    end
    
    def offer_params
      params.require(:offer).permit(:client_id, :user_id, :customer_id, :worker_id, :message)
    end
  end
  