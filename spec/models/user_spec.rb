require 'rails_helper'

describe User do
  context 'scope' do
    specify { expect(described_class.by_desc_points).to eq(described_class.order(points: :desc)) }
  end

  context 'associations' do
    specify { expect(subject).to have_many(:scores).with_foreign_key('created_by_id') }
    specify { expect(subject).to have_many(:opponent_scores).with_foreign_key('opponent_id').class_name('Score') }
  end

  context '#increment_points!' do
    it 'increments and saves points' do
      expect(subject).to receive(:save!).twice
      expect { subject.increment_points!(3) }.to change { subject.points }.from(0).to(3)
      expect { subject.increment_points!(4) }.to change { subject.points }.from(3).to(7)
    end
  end

  context '#increment_games_played!' do
    it 'increments and saves games_played by 1' do
      expect(subject).to receive(:save!).twice
      expect { subject.increment_games_played! }.to change { subject.games_played }.from(0).to(1)
      expect { subject.increment_games_played! }.to change { subject.games_played }.from(1).to(2)
    end
  end

  context '#opponents' do
    let(:me) { User.new(id: 30) }

    specify { expect(me.opponents).to eq(User.where.not(id: 30)) }
  end

  context '#score_history' do
    specify { expect(subject.score_history).to eq(subject.scores + subject.opponent_scores)}
  end
end