require 'rails_helper'

describe User do
  context 'associations' do
    specify { expect(subject).to have_many(:scores).with_foreign_key('created_by_id') }
  end

  context '#opponents' do
    let(:me) { User.new(id: 30) }

    specify { expect(me.opponents).to eq(User.where.not(id: 30)) }
  end
end