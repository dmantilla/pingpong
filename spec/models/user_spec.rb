require 'rails_helper'

describe User do
  context 'associations' do
    specify { expect(subject).to have_many(:scores).with_foreign_key('created_by_id') }
    specify { expect(subject).to have_many(:opponent_scores).with_foreign_key('opponent_id').class_name('Score') }
  end

  context '#opponents' do
    let(:me) { User.new(id: 30) }

    specify { expect(me.opponents).to eq(User.where.not(id: 30)) }
  end

  context '#score_history' do
    specify { expect(subject.score_history).to eq(subject.scores + subject.opponent_scores)}
  end
end