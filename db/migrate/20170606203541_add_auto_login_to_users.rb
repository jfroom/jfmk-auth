class AddAutoLoginToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :allow_auto_login, :boolean, default: false
  end
end
