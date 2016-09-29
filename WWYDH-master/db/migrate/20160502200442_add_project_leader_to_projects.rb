class AddProjectLeaderToProjects < ActiveRecord::Migration
  def change
    add_reference :projects, :project_leader, index: true, foreign_key: true
  end
end
