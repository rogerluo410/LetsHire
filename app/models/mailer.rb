class Mailer < ActionMailer::Base
  default from: 'LetsHire-ng'
#you can defind your email style here [this method for testing by garfield] .  
  def welcome_email(user)
    @user = user
    mail(to: @user.email, content_type: 'text/html',subject: 'Welcome to LetsHire-ng Site',body:'<h1>Welcome to LetsHire-ng '+@user.email+'</h1>')
  end

  def delegate_email(user)
    @user = user
    mail(to: @user.email, content_type: 'text/html',subject: 'This Email From  LetsHire-ng Site',body:'<h1>Hi '+@user.name+'</h1><br> <h2>you received interview message on LetsHire,please login LetsHire to view .<br><br> link location : <a href="http://10.111.104.220">LetsHire </a>  ''</h2>')
  end


end
