class AdminMailer < ApplicationMailer
  def activity_email(username, time, host, url, remote_ip, user_agent)
    @username = username
    @time = time
    @host = host
    @url = url
    @remote_ip = remote_ip
    @user_agent = user_agent
    subject = "[#{ENV.fetch('APP_NAME'){ 'APP_NAME' }.upcase}::#{Rails.env}] " \
              "User Activity: Login for @#{username}"
    mail subject: subject
  end
end
