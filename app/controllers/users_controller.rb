class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    if user_signed_in? && params[:user_id].present?
      @user = User.find(params[:user_id])
    end
    @user = User.find(params[:id])
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      #UserMailer.second_received_email(@user).deliver
      #UserMailer.second_send_email(@user).deliver
      redirect_to @user, notice: 'ご登録ありがとうございます。社内審査後、担当者よりご連絡差し上げます。'
    else
      render :edit
    end
  end

  def info
    @user = User.find(params[:id])
  end

  def payment
    @user = User.find(params[:id])
  end

  def conclusion
    @user = User.find(params[:id])
    today = Date.today.strftime("%Y-%m-%d")
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path, alert:"削除しました"
  end

  private

  def user_params
    params.require(:user).permit(:user_name, :email, :current_password, :password, :password_confirmation,
    :name,
    :age,
    :email,
    :experience,
    :voice_data,
    :year,
    :commodity,
    :hope,
    :period,
    :pc,
    :start,
    :tel,
    :agree_1,
    :agree_2,
    :emergency_name,
    :emergency_relationship,
    :emergency_tel,
    :identification,
    :bank,
    :branch,
    :bank_number,
    :bank_name,
    :status)
  end
end