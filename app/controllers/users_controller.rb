class UsersController < ApplicationController
  def index
    @q = User.ransack(params[:q])
    @users = @q.result(distinct: true)
             .order(updated_at: :desc)  # 更新日が新しい順
             .page(params[:page])
  end

  def new 
    @user = User.new
  end

  def thanks
  end
  
  def show
    #user_id = params[:user_id] || params[:id]
    @user = User.find(params[:id])
    @comment = Comment.new
  end  

  def edit
    @user = User.find(params[:id])
  end

  def info
    @user = User.find(params[:id])
  end

  def payment
    @user = User.find(params[:id])
  end


  def update
    @user = User.find(params[:id])
    previous_agree = @user.agree # 更新前の agree 状態を保持

    if @user.update(user_params)
      # 契約完了メール送信ロジック (agreeが変わった場合のみ)
      if @user.agree == "Agree" && previous_agree != "Agree"
        UserMailer.contract_received_email(@user).deliver_now
        UserMailer.contract_send_email(@user).deliver_now
        flash[:notice] = "契約が完了しました"
      end

      # リクエスト形式に応じてレスポンスを切り替える
      respond_to do |format|
        # 1. HTML形式でのリクエスト (通常のフォーム送信、リダイレクト)
        format.html { 
          redirect_to users_path 
        }
        
        # 2. JSON形式でのリクエスト (Ajaxによる status 更新)
        format.json { 
          render json: { 
            status: :ok, 
            message: 'Status updated successfully.',
            new_status: @user.status 
          }
        }
      end

    else
      # 更新に失敗した場合
      respond_to do |format|
        # 1. HTML形式でのリクエスト (edit画面に戻る)
        format.html { 
          render :edit 
        }
        
        # 2. JSON形式でのリクエスト (Ajaxエラー応答)
        format.json { 
          render json: { 
            status: :unprocessable_entity, 
            errors: @user.errors.full_messages 
          }, status: :unprocessable_entity 
        }
      end
    end
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

  def send_sms
    user = User.find(params[:id])
    SendSmsJob.perform_later(user.id)
    redirect_to users_path, notice: "#{user.name} に SMS を送信しました。"
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
    #Interviews
    :drivers_lisence,
    :car,
    :address,
    :change_the_address_check,
    :work_now,
    :experience,
    :which_visa,
    :japanese_level,   
    :visiting_in_japan, 
    :kanzi, 
    :start,
    # Users 
    :address_detail,   
    :drivers_up,   
    :emergency_name, 
    :emergency_relationships,
    :emergency_tel,  
    # Users
    :agree, 
    :check_1, 
    :check_2, 
    :check_3, 
    :check_4, 
    :check_5, 
    :check_6, 
    :check_7,

    :deliver,
    :day_off,
    :contract_date,

    :account_name,
    :image_1, 
    :image_2, 
    :image_3, 
    :image_4, 
    :image_5,
    :image_6,
    :bank,
    :branch,
    :bank_number,
    :bank_name,
    :status,
    )
  end
end