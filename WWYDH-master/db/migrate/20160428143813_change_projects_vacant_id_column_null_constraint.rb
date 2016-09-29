class ChangeProjectsVacantIdColumnNullConstraint < ActiveRecord::Migration
  def change
    change_column_null :projects, :vacant_id, false
  end
end
