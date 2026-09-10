# frozen_string_literal: true

class Clients::SessionsController < Devise::SessionsController
  protected

  def after_sign_in_path_for(resource)
    stored_location_for(resource)
    client_mypage_path
  end
end
