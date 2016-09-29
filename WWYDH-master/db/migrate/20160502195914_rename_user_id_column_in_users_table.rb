class RenameUserIdColumnInUsersTable < ActiveRecord::Migration
  def change
    rename_column :users, :user_id, :id
  end
end
