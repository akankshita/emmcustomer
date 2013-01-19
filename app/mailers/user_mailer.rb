class UserMailer < ActionMailer::Base
  default from: "from@example.com"
  def testing()
    #@user = user
    #attachments["rails.png"] = File.read("#{Rails.root}/public/images/rails.png")
    mail(:to => "akankshita.satapathy@php2india.com", :subject => "Testing")
  end
  
  def atest()
    #@user = user
    #attachments["rails.png"] = File.read("#{Rails.root}/public/images/rails.png")
    mail(:to => "akankshita.satapathy@php2india.com", :subject => "Another Testing")
  end
  
end
