# frozen_string_literal: true

class Clients::PasswordsController < Devise::PasswordsController
  protected

  def after_resetting_password_path_for(_resource)
    client_mypage_path
  end

  def after_sending_reset_password_instructions_path_for(_resource_name)
    new_client_session_path
  end
end
