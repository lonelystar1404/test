class RemoveProjectLeaderIdColumnFromProjectsTable < ActiveRecord::Migration
  def change
    remove_column :projects, :project_leader_id
  end
end
