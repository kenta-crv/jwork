class OrdersController < ApplicationController
  before_action :authenticate_user_or_client!
  before_action :set_user_or_client_and_associated, only: [:new, :create]

  def index 
    @orders = Order.all
  end  

  def new
    @worker = Worker.find(params[:worker_id])
    @order = @worker.orders.new
  end

  def show
    @order = Order.find(params[:id])
  end

  def create
    @worker = Worker.find(params[:order][:worker_id])
    @order = @worker.orders.new(order_params)
  
    # デバッグ情報
    Rails.logger.debug "Order Params: #{params[:order].inspect}"
    Rails.logger.debug "Worker ID: #{@worker.id}"
    Rails.logger.debug "Order Object Before Saving: #{@order.inspect}"
  
    @client = Client.find_by(id: params[:order][:client_id])
    @customer = Customer.find_by(id: params[:order][:customer_id])
  
    # デバッグ情報
    Rails.logger.debug "Found Client: #{@client.inspect}"
    Rails.logger.debug "Found Customer: #{@customer.inspect}"
  
    if @client.nil?
      Rails.logger.debug "Client not found, redirecting."
      redirect_to new_worker_order_path(@worker), alert: "Client not found."
      return
    end
  
    if @customer.nil?
      Rails.logger.debug "Customer not found, redirecting."
      redirect_to new_worker_order_path(@worker), alert: "Customer not found."
      return
    end
  
    @order.client = @client
    @order.customer = @customer
  
    if @order.save
      Rails.logger.debug "Order saved successfully."
      redirect_to confirm_worker_order_path(worker_id: @worker.id, id: @order.id)
    else
      Rails.logger.debug "Order errors: #{@order.errors.full_messages.inspect}"
      render :new
    end
  end


  def confirm
    @order = Order.find(params[:id])
  end

  def thanks
    @order = Order.find(params[:id])
    if @order.update(confirmed: true) # 確認済みとしてマークするカラムがあれば
      flash[:notice] = "打診が完了しました。マッチングがありましたらご連絡が入ります。"
      redirect_to workers_path
    else
      flash[:alert] = "登録が完了できませんでした。"
      redirect_to new_order_path
    end
  end

    # PATCH/PUT /orders/1
    def update
      if @order.update(order_params)
        redirect_to @order, notice: 'Order was successfully updated.'
      else
        render :edit
      end
    end
  
    # DELETE /orders/1
    def destroy
      @order.destroy
      redirect_to orders_url, notice: 'Order was successfully destroyed.'
    end
  
    private

    def authenticate_user_or_client!
      unless current_client || current_user 
        redirect_to new_client_session_path, alert: "ログインしてください。"
      end
    end
  
    def set_user_or_client_and_associated
      if current_client
        @client = current_client
        @customer = @client.customer
      elsif current_user
        @user = current_user
      end
    end
  
    def order_params
      params.require(:order).permit(:worker_id, :client_id, :customer_id, :message)
    end
  end
  