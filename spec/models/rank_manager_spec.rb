require 'rails_helper'

describe RankManager do
  let(:john)  { User.new(name: 'john' ) }
  let(:paul)  { User.new(name: 'paul' ) }
  let(:score) { Score.new(created_by: john, opponent: paul, score: 21, opponent_score: 12) }

  context 'class methods' do
    describe '.increment_counters' do
      it 'increments games_played on both participants' do
        expect(john).to receive(:increment_games_played!)
        expect(paul).to receive(:increment_games_played!)
        described_class.increment_counters(score)
      end
    end

    describe '.honour_points' do
      context 'wins over a player with less points' do
        it 'receives 3 points' do
          john.points = 10
          expect(john).to receive(:increment_points!).with(3)
          described_class.honour_points(score)
        end
      end

      context 'wins over a player with more points' do
        it 'receives 4 points' do
          john.points = 30
          paul.points = 50
          expect(john).to receive(:increment_points!).with(4)
          described_class.honour_points(score)
        end
      end
    end

    describe '.process' do
      it 'increments counters and honours points' do
        expect(described_class).to receive(:increment_counters).with(score)
        expect(described_class).to receive(:honour_points).with(score)
        described_class.process(score)
      end
    end

    describe 'score points' do
      specify { expect(described_class.win_points).to eq(3)}
      specify { expect(described_class.lose_points).to eq(0)}
      specify { expect(described_class.win_bonus_points).to eq(1)}
    end
  end
end