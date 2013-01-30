class UserMailer < ActionMailer::Base
  default from: "from@example.com"
  def testing()
    #@user = user
    #attachments["rails.png"] = File.read("#{Rails.root}/public/images/rails.png")
    mail(:to => "akankshita.satapathy@php2india.com", :subject => "Testing")
    #mail(:to => "daniel@php2india.com", :subject => "Testing")
  end
  
  def atest()
    #@user = user
    #attachments["rails.png"] = File.read("#{Rails.root}/public/images/rails.png")
    mail(:to => "akankshita.satapathy@php2india.com", :subject => "Another Testing")
    #mail(:to => "daniel@php2india.com", :subject => "Another Testing")
  end
  
  def ipnotavaialable(@customer_details)
    #@user = user
    #attachments["rails.png"] = File.read("#{Rails.root}/public/images/rails.png")
    #mail(:to => "akankshita.satapathy@php2india.com", :subject => "Ip Not Available")
    mail(:to => @customer_details.email, :subject => "Ip Not Available")
    #mail(:to => "daniel@php2india.com", :subject => "Ip Not Available")
  end
  def incorrecttime(@customer_details)
    #@user = user
    #attachments["rails.png"] = File.read("#{Rails.root}/public/images/rails.png")
    #mail(:to => "akankshita.satapathy@php2india.com", :subject => "Incorrect Time")
    #mail(:to => "daniel@php2india.com", :subject => "Incorrect Time")
    mail(:to => @customer_details.email, :subject => "Incorrect Time")
  end
  
end
