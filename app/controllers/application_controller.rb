class ApplicationController < ActionController::Base
  protect_from_forgery
   before_filter :check_login
  def check_login
    #ActiveRecord::Base.establish_connection("developemnt")
#begin    
    ActiveRecord::Base.establish_connection(
        :adapter  => "postgresql",
        :host     => "ec2-54-243-238-144.compute-1.amazonaws.com",#"ec2-54-243-238-144.compute-1.amazonaws.com",
        :username => "mbqnxvumycnhxs",#izqcdmliwozmgx",
        :port => 5432,
        :password =>"lC_HYsKxXsJerxoLpR_a5sMAwg", #"35JS51QKt5gQHm2HOH2D97p7kZ",
        :database => "d89hd8fvckog43"#"d5v3qoof2vr5rs"
    )
#end    
   # render :text => $global_variable.inspect and return false
    if session[:login_id].nil?
       redirect_to '/'
    end
  end
end
