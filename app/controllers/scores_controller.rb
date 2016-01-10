class ScoresController < ApplicationController
  before_action :authenticate_user!

  def new
    @score = current_user.scores.build
  end

  def create
    @score = current_user.scores.build(score_params)
    if @score.save
      redirect_to root_path
    else
      render action: :new
    end
  end

  protected

  def score_params
    params.require(:score).permit(:date_played, :opponent_id, :score, :opponent_score)
  end
end
