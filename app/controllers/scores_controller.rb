class ScoresController < ApplicationController
  before_action :authenticate_user!

  def index
    @history = current_user.score_history.sort_by { |s| s.date_played }
  end

  def new
    @score = current_user.scores.build
  end

  def create
    @score = current_user.scores.build(score_params)
    if @score.save
      redirect_to action: :index
    else
      render action: :new
    end
  end

  protected

  def score_params
    params.require(:score).permit(:date_played, :opponent_id, :score, :opponent_score)
  end
end
