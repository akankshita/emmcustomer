class ApplicationController < ActionController::Base
  protect_from_forgery
   before_filter :check_login
  def check_login
   # render :text => $global_variable.inspect and return false
    if session[:login_id].nil?
       redirect_to '/'
    end
  end
end
