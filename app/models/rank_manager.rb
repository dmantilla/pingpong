class RankManager

  class << self
    def increment_counters(score)
      score.created_by.increment_games_played!
      score.opponent.increment_games_played!
    end

    def honour_points(score)
      winner = score.winner
      loser = score.loser
      points = win_points
      # Bonus points for winning a person with more points
      points += win_bonus_points if loser.points > winner.points
      winner.increment_points!(points)
    end

    def process(score)
      increment_counters(score)
      honour_points(score)
    end

    # Helpers to get points from configuration file, lazy loaded

    def point_values
      @@point_values ||= Rails.application.secrets.points
    end

    def win_points
      point_values['win']
    end

    def lose_points
      point_values['lose']
    end

    def win_bonus_points
      point_values['win_bonus']
    end
  end
end