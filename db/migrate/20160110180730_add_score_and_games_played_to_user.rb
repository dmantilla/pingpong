class AddScoreAndGamesPlayedToUser < ActiveRecord::Migration
  def change
    add_column :users, :score, :integer, null: false, default: 0
    add_column :users, :games_played, :integer, null: false, default: 0
  end
end
