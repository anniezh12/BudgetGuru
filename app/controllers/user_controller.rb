require 'rack-flash'
class UserController < ApplicationController
      use Rack::Flash
      get '/signup' do
          if is_logged_in?
               @user = current_user
               flash[:message] =  "you are already logged in "
               erb :'/accounts/display_accounts'
          else
               erb :'users/create_user'
          end
      end

      post '/signup' do
          if params[:username].empty? || params[:password].empty? || params[:re_password].empty? || params[:email].empty?
               flash[:message] =   "All Fields must be filled"
               erb :'/users/create_user'
          elsif params[:password] != params[:re_password]
               flash[:message] =   "Password must be same in Retype field"
               erb :'/users/create_user'
          else
               @user = User.new(username: params[:username],password: params[:password],email: params[:email])
               @user.save
               session[:id] = @user.id
               flash[:message] = "You Can see all your accounts"
               redirect "/accounts"
          end
      end

      get '/login' do
         if is_logged_in?
           redirect "/accounts"
         else
           erb :'/users/login'
         end
      end

      post '/login' do
         if is_logged_in?
           redirect "/accounts"
         else
           @user = User.find_by(username: params[:username])
           if @user && @user.authenticate(params[:password])
             flash[:message] = ""
             session[:id] = @user.id
             redirect "/accounts"
           else
             flash[:message] = "User Name and Password not found, Please try again"
             erb :'users/login'
           end
         end
      end

       get '/users/:slug' do
          @user = User.find_by_slug(params[:slug])
          redirect "/accounts"
        end

       get '/logout' do
          if session[:id] != nil
              session.clear
              redirect "/"
          end
       end
end
