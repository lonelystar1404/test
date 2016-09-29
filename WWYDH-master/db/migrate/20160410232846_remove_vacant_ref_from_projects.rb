class RemoveVacantRefFromProjects < ActiveRecord::Migration
  def change
    remove_column :projects, :vacant_id
  end
end
