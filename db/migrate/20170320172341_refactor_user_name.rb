class RefactorUserName < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :last_name, :string, limit: 32
    rename_column :users, :first_name, :name
  end
end
