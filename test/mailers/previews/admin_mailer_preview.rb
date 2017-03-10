# Preview all emails at http://localhost:3000/rails/mailers/admin_mailer
class AdminMailerPreview < ActionMailer::Preview
  def activity_email
    r = ActionDispatch::TestRequest.create({})
    AdminMailer.activity_email 'username', Time.zone.now.to_s, r.host, r.url, r.remote_ip, r.user_agent
  end
end
