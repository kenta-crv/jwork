class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def new 
    @user = User.new
  end

  def thanks
  end
  
  def show
    #user_id = params[:user_id] || params[:id]
    @user = User.find(params[:id])
  end  

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = current_user
    if @user.update(user_params)
      UserMailer.second_received_email(@user).deliver
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
    :tel,
    :age,
    :email,
    :nationality, #国籍
    :past_business, #業種
    :past_genre, #職種
    :past_year, #年数
    :qualifications, #資格
    :work_range, #働ける範囲
    :hope_work, #希望職種
    :hope_other, #その他希望
    :line, #ライン登録
    :period, #何ヶ月以内
    :recommend, #オススメ度
    :remarks, #備考
    :conversation,
    :resume,
    :available,
    :different,
    :call_check,     #日本語チェック
    :call_impressions,     #電話の印象
    :change_the_address,     #都道府県変更
    :call_available,     #電話可能時間
    :speak_japanese,     #日本語会話
    :gender,     #性別
    )
  end
end