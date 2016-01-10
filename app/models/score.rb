class Score < ActiveRecord::Base
  belongs_to :created_by, class_name: 'User'
  belongs_to :opponent, class_name: 'User'

  validates :date_played, presence: true
  validates :opponent_id, :created_by_id, presence: true
  validates :score, :opponent_score, numericality: { greater_than: 0, less_than_or_equal_to: 21 }

  validate  :must_not_be_in_the_future
  validate  :must_have_valid_scores

  protected

  def must_not_be_in_the_future
    errors.add(:date_played, 'can not be in the future') if date_played && (date_played > Date.today)
  end

  def must_have_valid_scores
    return unless score && opponent_score
    errors.add(:base, 'One of the scores has to be 21') unless (score == 21 && opponent_score != 21) || (score != 21 && opponent_score == 21)
    errors.add(:base, 'There has to be a difference of at least 2 points between scores') if (score - opponent_score).abs < 2
  end
end
