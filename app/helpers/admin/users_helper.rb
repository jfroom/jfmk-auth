module Admin::UsersHelper
  def user_attributes
    ['username', 'name', 'admin', 'login_locked', 'login_attempts']
  end
end
