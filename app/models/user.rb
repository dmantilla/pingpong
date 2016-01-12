class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :trackable, :validatable

  has_many :scores, foreign_key: 'created_by_id'
  has_many :opponent_scores, foreign_key: 'opponent_id', class_name: 'Score'

  scope    :by_desc_points, -> { order(points: :desc) }

  def increment_points!(value)
    self.points += value
    save!
  end

  def increment_games_played!
    self.games_played += 1
    save!
  end

  def opponents
    User.where.not(id: self.id)
  end

  def score_history
    scores + opponent_scores
  end
end
