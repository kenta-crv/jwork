# frozen_string_literal: true

class Partners::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]
  before_action :configure_permitted_parameters, if: :devise_controller?


def create
  @partner = Partner.new(sign_up_params)

  if @partner.save
    # 管理者でない場合のみメール送信
    unless admin_signed_in?
      PartnerMailer.received_email(@partner).deliver
      PartnerMailer.send_email(@partner).deliver
    end

    redirect_to partner_path(id: @partner.id), notice: '登録が完了しました。以下より契約へお進みください。'
  else
    render 'partners/registrations/new'
  end
end


  protected

  def after_sign_up_path_for(resource)
    partner_path(id: resource.id)  # ✅ ここでリダイレクトを制御
  end

  # アカウント更新後のリダイレクト先
  def after_update_path_for(resource)
    "/partners/#{current_partner.id}"  
  end

  private
  def configure_permitted_parameters
    added_attrs = [
      :company, :post_title, :representative_name, :contact_name, :tel, :email, :address, :url, :message, :agree, :contract_date, :question_people, :question_attractive, :question_open, :question_prediction, :agree_1, :agree_2, :agree_3, :agree_4, :agree_5, :agree_6, :agree_7
    ]
  
    devise_parameter_sanitizer.permit(:sign_up, keys: added_attrs)
    devise_parameter_sanitizer.permit(:account_update, keys: added_attrs)
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
