class ChangeProjectsNullConstraints < ActiveRecord::Migration
  def change
    change_column_null :projects, :title, false
    change_column_null :projects, :description, false
  end
end
