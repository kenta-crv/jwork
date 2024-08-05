class ClientsController < ApplicationController
  def show
    @client = Client.find(params[:id])
  end


  def edit
    @client = current_client
  end

  def update
    @client = current_client
    if @client.update(client_params)
      redirect_to @client, notice: 'プロフィールが更新されました'
    else
      render :edit
    end
  end

  private

  def client_params
    params.require(:client).permit(:user_name, :email, :current_password, :password, :password_confirmation)
  end
end