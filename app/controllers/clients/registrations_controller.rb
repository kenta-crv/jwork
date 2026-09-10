# frozen_string_literal: true

class Clients::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?

  def create
    build_resource(mapped_sign_up_params)

    if resource.save
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        redirect_to client_mypage_path and return
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        redirect_to after_inactive_sign_up_path_for(resource) and return
      end
    end

    clean_up_passwords resource
    set_minimum_password_length
    render :new
  end

  protected

  def after_sign_up_path_for(resource)
    client_mypage_path
  end

  def after_update_path_for(resource)
    client_mypage_path
  end

  private

  def configure_permitted_parameters
    added_attrs = [
      :company, :post_title, :representative_name, :contact_name, :tel, :email,
      :address, :url, :password, :password_confirmation, :recruit_url, :visa,
      :message, :number, :house_support, :house_agents, :business, :genre,
      :salary, :work_time, :day_off, :work_contents, :remarks,
      :position, :person, :mobile, :industry
    ]
    devise_parameter_sanitizer.permit(:sign_up, keys: added_attrs)
    devise_parameter_sanitizer.permit(:account_update, keys: added_attrs)
  end

  def mapped_sign_up_params
    raw = sign_up_params
    {
      company: raw[:company],
      position: raw[:post_title].presence || raw[:position],
      person: raw[:contact_name].presence || raw[:representative_name].presence || raw[:person],
      tel: raw[:tel],
      email: raw[:email],
      address: raw[:address],
      url: raw[:url],
      remarks: [
        raw[:remarks],
        ("求人URL: #{raw[:recruit_url]}" if raw[:recruit_url].present?),
        ("ビザ: #{Array(raw[:visa]).reject(&:blank?).join(', ')}" if raw[:visa].present?),
        ("受入申請経験: #{raw[:message]}" if raw[:message].present?),
        ("採用人数: #{raw[:number]}" if raw[:number].present?),
        ("住居サポート: #{raw[:house_support]}" if raw[:house_support].present?),
        ("住居フォロー: #{raw[:house_agents]}" if raw[:house_agents].present?),
        ("募集業種: #{raw[:business]}" if raw[:business].present?),
        ("募集職種: #{raw[:genre]}" if raw[:genre].present?),
        ("給料条件: #{raw[:salary]}" if raw[:salary].present?),
        ("勤務時間: #{raw[:work_time]}" if raw[:work_time].present?),
        ("休日: #{raw[:day_off]}" if raw[:day_off].present?),
        ("業務内容: #{raw[:work_contents]}" if raw[:work_contents].present?)
      ].compact.join("\n"),
      password: raw[:password],
      password_confirmation: raw[:password_confirmation]
    }
  end
end
