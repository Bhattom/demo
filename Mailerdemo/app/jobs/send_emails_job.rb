class SendEmailsJob < ApplicationJob
  queue_as :default

  def perform(*user)
    UserMailer.welcome_email(@user).deliver_later
    puts "Welcome to website"
  end
end
