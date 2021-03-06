class SessionsController < ApplicationController
  before_action :check_logged_in, only: %i[index login auto_login]
  skip_before_action :login_required

  def login
    user = User.authenticate!(params[:username], params[:password])
    if user.present?
      process_login user

      # Admin goes to admin page, all other users go to root content page
      redirect_to user.admin? ? admin_root_path : root_path
    else
      flash.now[:alert] =
        if User.is_login_locked?(params[:username])
          "Username is locked. Please contact the administrator to reset."
        else
          "Invalid username or password."
        end
      @username = params[:username]
      render :index
    end
  end

  def logout
    reset_session
    flash[:info] = "You have been logged out."
    redirect_to root_path
  end

  def auto_login
    user = User.find_by_username params[:username]
    if user.present? && user.allow_auto_login
      process_login user, true
    else
      flash[:alert] = "Invalid username."
    end
    redirect_to root_path
  end

  private

  # Trying to access login page when already logged in? Redirect to home page
  def check_logged_in
    if session[:user_id]
      redirect_to root_path
      return false
    end
    true
  end

  def process_login(user, is_auto_login = false)
    reset_session
    session[:user_id] = user.id

    # Email notify admin of a user login
    return if user.admin? || ENV['IS_DEMO_MODE'] == '1'
    notify_login user.username, is_auto_login
  end

  def notify_login(username, is_auto_login)
    AdminMailer.activity_email(username, is_auto_login, Time.zone.now.to_s,
                               request.host, request.url, request.remote_ip, request.user_agent).deliver_later
  # Log any errors silently so user can still login
  rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError,
         Net::SMTPUnknownError => e
    logger.error e.message
    NewRelic::Agent.notice_error e
  end
end
