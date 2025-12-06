class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?

    def create
    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?

    if resource.persisted?
      if resource.active_for_authentication?
        # Devise の既定の処理（フラッシュ・サインイン）
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)

        # --- ここで実行する処理 ---
        SendSmsJob.perform_now(resource.id)
        UserMailer.send_email(resource).deliver_now
        # ---------------------------

        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      # 保存失敗時は通常通り new に戻す
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  def after_sign_up_path_for(resource)
    "/users/thanks"
  end

  private

  def configure_permitted_parameters
    additional_keys = [
      :user_name, :email, :current_password, :password, :password_confirmation,
      :name, :tel, :age, :nationality, :past_business, :past_genre, :past_year,
      :qualifications, :work_range, :hope_work, :hope_other, :line, :period,
      :recommend, :remarks, :conversation, :resume, :available, :different,
      :call_check, :call_impressions, :change_the_address, :call_available, :speak_japanese, :gender, :status
    ]

    devise_parameter_sanitizer.permit(:sign_up, keys: additional_keys)
    devise_parameter_sanitizer.permit(:account_update, keys: additional_keys)
  end

  def update_resource(resource, params)
  # パスワードなしで更新できるようにする
    resource.update_without_password(params)
  end

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
