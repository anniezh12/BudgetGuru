require './config/environment'
require 'pry'
require 'rack-flash'

class ApplicationController < Sinatra::Base
      use Rack::Flash
      configure do
          set :public_folder, 'public'
          set :views,'app/views'
          enable :sessions
          set :session_secret,"secret"
      end

      get '/' do
          erb :homepage
      end

      def is_logged_in?
          session.has_key?(:id) ? true : false
      end

      def current_user
          User.find_by_id(session[:id])
      end
end
