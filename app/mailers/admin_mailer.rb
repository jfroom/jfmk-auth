class AdminMailer < ApplicationMailer
  def activity_email(user, request, time)
    @user = user
    @request = request
    @time = time
    subject = "[#{ENV['APP_NAME'].upcase}::#{Rails.env}] " \
              "User Activity: Login for #{user.first_name} #{user.last_name}, @#{user.username}"
    mail subject: subject
  end
end
