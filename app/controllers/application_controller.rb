class ApplicationController < ActionController::Base

private
 def after_sign_in_path_for(resource)
   case resource
   when Admin
    clients_path
   when User
    user_path(resource)
   when Client
    stored_location_for(resource)
    client_mypage_path
   else
     super
   end
 end

 def after_sign_out_path_for(resource)
   case resource
   when Admin, :admin, :admins
     root_path
   when User, :user, :users
     root_path
   when Client, :client, :clients
    root_path
   else
     super
   end
 end
end
