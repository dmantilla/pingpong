class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :trackable, :validatable

  has_many :scores, foreign_key: 'created_by_id'

  scope    :by_final_score, -> { order(score: :desc) }

  def opponents
    User.where.not(id: self.id)
  end

end
