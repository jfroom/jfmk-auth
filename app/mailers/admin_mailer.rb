class AdminMailer < ApplicationMailer
  def activity_email(username, is_auto_login, time, host, url, remote_ip, user_agent)
    @username = username
    activity = is_auto_login ? "Auto-Login" : "Login"
    @time = time
    @host = host
    @url = url
    @remote_ip = remote_ip
    @user_agent = user_agent
    subject = "[#{ENV.fetch('APP_NAME'){ 'APP_NAME' }.upcase}::#{Rails.env}] " \
              "User Activity: #{activity} for @#{@username}"
    mail subject: subject
  end
end
