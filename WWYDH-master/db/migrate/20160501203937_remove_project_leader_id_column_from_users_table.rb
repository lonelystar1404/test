class RemoveProjectLeaderIdColumnFromUsersTable < ActiveRecord::Migration
  def change
    remove_column :users, :project_leader_id
  end
end
