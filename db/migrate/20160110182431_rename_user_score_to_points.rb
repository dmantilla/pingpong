class RenameUserScoreToPoints < ActiveRecord::Migration
  def change
    rename_column :users, :score, :points
  end
end
