module Admin::UsersHelper
  def user_attributes
    %w[username name admin allow_auto_login login_locked login_attempts]
  end
end
