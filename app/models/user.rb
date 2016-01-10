class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :trackable, :validatable

  has_many :scores, foreign_key: 'created_by_id'
  has_many :opponent_scores, foreign_key: 'opponent_id', class_name: 'Score'

  scope    :by_final_score, -> { order(score: :desc) }

  def opponents
    User.where.not(id: self.id)
  end

  def score_history
    scores + opponent_scores
  end
end
