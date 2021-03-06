require 'rails_helper'

describe Score, type: :model do
  let(:today) { Date.parse('2016-01-01') }
  let(:john)  { User.new(name: 'john' ) }
  let(:paul)  { User.new(name: 'paul' ) }

  context 'associations' do
    it { expect(subject).to belong_to(:created_by).class_name('User') }
    it { expect(subject).to belong_to(:opponent).class_name('User') }
  end

  context 'validations' do
    it { expect(subject).to validate_presence_of(:date_played) }
    it { expect(subject).to validate_presence_of(:opponent_id) }
    it { expect(subject).to validate_presence_of(:created_by_id) }
    it { expect(subject).to validate_numericality_of(:score).is_greater_than(0).is_less_than_or_equal_to(21) }
    it { expect(subject).to validate_numericality_of(:opponent_score).is_greater_than(0).is_less_than_or_equal_to(21) }

    describe 'must not be in the future' do
      specify 'today is ok' do
        expect(Date).to receive(:today).and_return(today)
        subject.date_played = today
        subject.valid?
        expect(subject.errors[:date_played]).to be_empty
      end

      specify 'yesterday is ok' do
        expect(Date).to receive(:today).and_return(today)
        subject.date_played = today - 1.day
        subject.valid?
        expect(subject.errors[:date_played]).to be_empty
      end

      specify 'tomorrow is not ok' do
        expect(Date).to receive(:today).and_return(today)
        subject.date_played = today + 1.day
        subject.valid?
        expect(subject.errors[:date_played]).not_to be_empty
      end
    end

    describe 'must have valid scores' do
      context 'either score has to be 21' do
        specify '21 vs 18 is ok' do
          subject.attributes = { score: 21, opponent_score: 18 }
          subject.valid?
          expect(subject.errors[:base]).to be_empty
        end

        specify '18 vs 21 is ok' do
          subject.attributes = { score: 18, opponent_score: 21 }
          subject.valid?
          expect(subject.errors[:base]).to be_empty
        end

        specify '10 vs 18 is not ok' do
          subject.attributes = { score: 10, opponent_score: 18 }
          subject.valid?
          expect(subject.errors[:base]).not_to be_empty
        end

        specify '18 vs 10 is not ok' do
          subject.attributes = { score: 18, opponent_score: 10 }
          subject.valid?
          expect(subject.errors[:base]).not_to be_empty
        end

        specify '21 vs 21 is not ok' do
          subject.attributes = { score: 21, opponent_score: 21 }
          subject.valid?
          expect(subject.errors[:base]).not_to be_empty
        end

        specify '21 vs 19 is ok' do
          subject.attributes = { score: 21, opponent_score: 19 }
          subject.valid?
          expect(subject.errors[:base]).to be_empty
        end

        specify '19 vs 21 is ok' do
          subject.attributes = { score: 19, opponent_score: 21 }
          subject.valid?
          expect(subject.errors[:base]).to be_empty
        end
      end
    end
  end

  describe '#results' do
    it 'returns results based on the caller' do
      subject.attributes = { created_by: john, opponent: paul, score: 21, opponent_score: 19}
      expect(subject.results(john)).to eq({adversary: paul, score: 21, opponent_score: 19, is_winner: true})
      expect(subject.results(paul)).to eq({adversary: john, score: 19, opponent_score: 21, is_winner: false})
    end
  end

  describe '#winner & #loser' do
    it 'returns the winner' do
      subject.attributes = { created_by: john, opponent: paul, score: 21, opponent_score: 19}
      expect(subject.winner).to eq(john)
      expect(subject.loser).to eq(paul)
    end

    it 'returns the winner again' do
      subject.attributes = { created_by: john, opponent: paul, score: 15, opponent_score: 21}
      expect(subject.winner).to eq(paul)
      expect(subject.loser).to eq(john)
    end
  end
end
