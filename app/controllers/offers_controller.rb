class OffersController < ApplicationController
  before_action :authenticate_user_or_client!
  before_action :set_user_or_client_and_associated, only: [:new, :create]

  def index
    @offers = Offer.all
  end

  def show
    @offer = Offer.find(params[:id])
  end

  def new
    if user_signed_in?
      @client = Client.find(params[:client_id])
      @offer = @client.offers.new(user_id: current_user.id) # クライアントのIDを引き継ぐ
    elsif client_signed_in?
      @user = User.find(params[:user_id])
      @offer = @user.offers.new(client_id: current_client.id) # クライアントのIDを引き継ぐ
    else
      redirect_to root_path, alert: 'サインインしてください'
    end
  end

  def create
    @offer = Offer.new(offer_params)
    if @offer.save
      redirect_to offers_path, notice: 'オファーが作成されました'
    else
      render :new
    end
  end

  def thanks
    @offer = Offer.find(params[:id])
    if @offer.update(confirmed: true) # 確認済みとしてマークするカラムがあれば
      flash[:notice] = "打診が完了しました。マッチングがありましたらご連絡が入ります。"
      redirect_to clients_path
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
      if user_signed_in?
        @user = current_user
      elsif client_signed_in?
        @client = current_client
      end
    end
  
  
    
    def offer_params
      params.require(:offer).permit(:client_id, :user_id, :client_id, :user_id, :message)
    end
  end
  