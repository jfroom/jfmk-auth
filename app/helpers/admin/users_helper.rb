module Admin::UsersHelper
  def user_attributes
    %w(username name admin login_locked login_attempts)
  end
end
