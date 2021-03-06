require "test_helper"
require "acceptance/page_obs/sessions_page"
require "acceptance/page_obs/proxy_page"

class SessionsTest < AcceptanceTest
  before do
    @sessions_page = SessionsPage.new
    @proxy_page = ProxyPage.new
  end

  def verify_login_page
    assert_current_path login_path
    assert @sessions_page.has_username_input?
    assert @sessions_page.has_password_input?
    assert @sessions_page.element_has_focus('username')
  end

  test "Login fail, locking, success" do
    # Root url immediately redirects to login_path because it's a new session
    visit root_path

    verify_login_page
    assert @sessions_page.has_alert_count?(0)
    assert @sessions_page.submit_disabled?

    # Invalid login. No user in db
    @sessions_page.fill_login 'nobody'
    assert @sessions_page.submit_disabled?
    @sessions_page.fill_login 'nobody', '123'
    assert @sessions_page.submit_enabled?
    @sessions_page.click_login_btn
    assert @sessions_page.element_has_focus('username')
    assert @sessions_page.has_login_alert?
    assert @sessions_page.has_username_input?('nobody') # Username repopulates after submit
    assert @sessions_page.has_no_password? # Password empty after submit
    @sessions_page.dismiss_alert

    # Invalid login. Valid user, wrong password.
    client_user = User.find_by_username('client')
    2.times do
      @sessions_page.fill_login client_user.username, '123'
      @sessions_page.click_login_btn
      assert @sessions_page.has_login_alert?
      assert @sessions_page.has_alert_count?(1)
    end

    # 3rd time locks user out
    @sessions_page.fill_login client_user.username, '123'
    @sessions_page.send_input_enter_key
    assert @sessions_page.has_lock_alert?
    assert @sessions_page.has_alert_count?(1)

    # Locked thereafter
    @sessions_page.fill_login client_user.username, '123'
    @sessions_page.click_login_btn
    assert @sessions_page.has_lock_alert?
    assert @sessions_page.has_alert_count?(1)

    # User locked from before
    locked_user = User.find_by_username('clientlocked')
    @sessions_page.fill_login locked_user.username, 'Secret1'
    @sessions_page.click_login_btn
    assert @sessions_page.has_lock_alert?
    assert @sessions_page.has_alert_count?(1)

    # Acme client logs in successfully
    acme_user = User.find_by_username('acme')
    @sessions_page.fill_login acme_user.username, 'Secret1'
    @sessions_page.click_login_btn
    assert @sessions_page.has_alert_count?(0)

    # Content page finally loads
    assert_current_path root_path
    assert @proxy_page.has_proxy_content?

    # User stays logged in upon reload
    reload!
    assert_current_path root_path
    assert @proxy_page.has_proxy_content?

    # Going to login page when logged in redirects to home page
    visit login_path
    assert_current_path root_path

    # Logout
    visit logout_path
    assert_current_path login_path
    assert @sessions_page.has_logout_alert?
    verify_login_page

    # Still logged out after reload
    reload!
    assert_current_path login_path
    assert @sessions_page.has_alert_count?(0)
    verify_login_page

    # Acme client not allowed to login automatically
    visit root_path + 'acme'
    assert_current_path login_path
    assert @sessions_page.has_invalid_username_alert?

    # User with allow_auto_login
    visit root_path + 'clientautologin'
    assert_current_path root_path
    assert @proxy_page.has_proxy_content?
    assert @sessions_page.has_alert_count?(0)
  end
end
