class ChangeProjectsStageColumnDefault < ActiveRecord::Migration
  def change
    change_column_default :projects, :stage, 1
  end
end
