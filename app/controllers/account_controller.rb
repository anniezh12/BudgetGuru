require 'pry'
require 'rack-flash'
class AccountController < ApplicationController

      use Rack::Flash
      get '/accounts' do
          if is_logged_in?
              @user = User.find_by_id(session[:id])
              erb :'/accounts/display_accounts'
          else
              flash[:message] = "You should Log In first"
              redirect "/login"
          end
      end

      post '/accounts' do
          if params[:card_type] == "" || params[:currentbalance] == "" || params[:statemetbalance] == "" || params[:creditlimit] == "" || params[:duedate] == ""
              flash[:message] = "Please fill in all the fields"
              erb :'/accounts/add_account'
          elsif is_logged_in? && current_user
              @account = Account.create(card_type: params[:cardtype],current_balance: params[:currentbalance],statement_balance: params[:statementbalance],credit_limit: params[:creditlimit],due_date: params[:duedate])
              @account.save
              current_user.accounts << @account
              flash[:message] = "you Have succesfully added your #{@account.card_type} to your dashboard!"
              redirect "/accounts"
          else
              redirect "/login"
          end
      end

      get '/accounts/new' do
          erb :'/accounts/add_account'
      end

      post '/accounts/new' do
         erb :'/accounts/add_account'
      end

      post '/accounts/edit' do
          if is_logged_in? && params.present?
              @account = Account.find_by_id(params["user"]["account_ids"])
              redirect "/accounts/#{@account.id}/edit"
          else
              flash[:message] = "please select a card to be edited"
              redirect "/accounts"
          end
      end

      get '/accounts/:user' do
          @user = User.find_by(username: params[:user])
          if @user && session[:id] == @user.id
              erb :'/accounts/display_accounts'
          elsif current_user != @user
              flash[:message] = "Not #{current_user.username.upcase}! Please Login to your account "
              erb :'/users/login'
          else
              flash[:message] =  "You need to login to see your Info!"
              erb :'/users/login'
          end
      end

      get '/accounts/:id/edit' do
          if is_logged_in?
              @account = Account.find_by_id(params[:id])
              if @account != nil
              erb :'/accounts/edit_account'
              else
              flash[:message] =  "No such account found!"
              erb :'/accounts'
              end
          else
              flash[:message] =  "You are not authorised to edit this account, Please Log In to your account"
              redirect "/login"
          end
      end

      post '/accounts/:id/edit' do
          if params[:card_type] == "" || params[:currentbalance] == "" || params[:statemetbalance] == "" || params[:creditlimit] == "" || params[:duedate] == ""
              flash[:message] = "Please fill in all the fields"
              redirect "/accounts/#{params[:id]}/edit"
          else
              @account = Account.find_by_id(params[:id])
              if @account.user_id = current_user.id
                if  @account.update(card_type: params[:cardtype],current_balance: params[:currentbalance],statement_balance: params[:statementbalance],credit_limit: params[:creditlimit],due_date: params[:duedate])
                 flash[:message] = "You have successfully edited #{@account.card_type} card!"
                 redirect "/accounts"
                end
              end
          end
      end

      get '/accounts/:id/delete' do
            if is_logged_in?
                @account = Account.find_by_id(params[:id])
                if current_user == @account.user
                    cardtype = @account.card_type
                    @account.delete
                    flash[:message] = "#{cardtype} Successfuly Deleted"
                    redirect '/accounts'
                else
                    flash[:message] = "Please login to corresponding account to delete this account"
                    erb :'/users/login'
                end
             else
                  flash[:message] = "You are not authorized to delete this account"
             end
        end
end
