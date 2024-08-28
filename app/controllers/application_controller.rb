class ApplicationController < ActionController::Base

private
 def after_sing_in_path_for(resource)
   case resource
   when Admin
    admin_path
   when User
    user_path
   when Client
    client_path
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
