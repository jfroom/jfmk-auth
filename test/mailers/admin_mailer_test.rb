require 'test_helper'

class AdminMailerTest < ActionMailer::TestCase

  test "user activity" do

    def test_content(email, username)
      # Test the body of the sent email contains what we expect it to
      assert_equal [ENV['ACTION_MAILER_DEFAULT_FROM']], email.from
      assert_equal [ENV['ACTION_MAILER_DEFAULT_TO']], email.to
      subject = "[#{ENV.fetch('APP_NAME'){ 'APP_NAME' }.upcase}::#{Rails.env}] "\
                "User Activity: Login for @#{username}"
      assert_equal subject, email.subject
      assert_equal read_fixture('activity_email.html').join, email.html_part.body.to_s
      assert_equal read_fixture('activity_email.text').join, email.text_part.body.to_s
    end

    # Create the email and store it for further assertions
    now = '2017-03-07 15:26:40 -0800' # Time.zone.now
    request = ActionDispatch::TestRequest.create({})
    username = 'client'
    args = username, now, request.host, request.url, request.remote_ip, request.user_agent
    email = AdminMailer.activity_email *args

    # Test delivery now
    assert_emails 1 do
      email.deliver_now
    end
    delivered_email = ActionMailer::Base.deliveries.last
    test_content delivered_email, username

    # Test deliver_later
    ActiveJob::Base.queue_adapter = :test
    email = AdminMailer.activity_email *args
    assert_enqueued_emails 1 do
      email.deliver_later
    end
    delivered_email = perform_enqueued_jobs { ActionMailer::DeliveryJob.perform_now(*enqueued_jobs.first[:args]) }
    test_content delivered_email, username
  end
end
