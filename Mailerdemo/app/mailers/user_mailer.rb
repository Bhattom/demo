class UserMailer < ApplicationMailer
  before_action { @user = params[:user] }


  default from: 'notifications@example.com'

    def welcome_email
      return unless @user
         @user = params[:user]
        @url = "http://example.com/login"
        attachments.inline['images.jpeg'] = File.read('app/assets/images/images.jpeg')
        attachments.inline['img.jpeg'] = File.read('app/assets/images/img.jpeg')
        mail(
          to: email_address_with_name(@user.email, @user.name),
          subject: 'Welcome to My  Website'
        )
    end


  end