class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.date :date_played
      t.integer :opponent_id
      t.integer :created_by_id
      t.integer :score
      t.integer :opponent_score

      t.timestamps null: false
    end
  end
end
