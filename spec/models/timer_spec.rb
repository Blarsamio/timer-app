require 'rails_helper'

RSpec.describe Timer, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:duration) }
    it { should validate_numericality_of(:duration).is_greater_than(0) }
  end

  describe 'associations' do
    it { should belong_to(:session) }
  end
end

RSpec.describe Timer, 'asana link', type: :model do
  it 'links to the library asana matching its title' do
    sphinx = create(:asana, title: 'Sphinx and Seal')
    expect(create(:timer, title: 'Sphinx').asana).to eq(sphinx)
  end
end

RSpec.describe Timer, 'segment fields', type: :model do
  let(:session) { create(:session) }

  it 'infers kind from the title' do
    expect(Timer.kind_for('Switch Pose')).to eq('rebound')
    expect(Timer.kind_for('Shavasana')).to eq('savasana')
    expect(Timer.kind_for('Opening Meditation')).to eq('centering')
    expect(Timer.kind_for('Finishing Meditation')).to eq('closing')
    expect(Timer.kind_for('Dragonfly')).to eq('pose')
  end

  it 'takes the first side word from the instruction' do
    expect(Timer.side_for('Left knee on top')).to eq('left')
    expect(Timer.side_for('right arm under left')).to eq('right')
    expect(Timer.side_for(nil, 'Bananasana to the right')).to eq('right')
    expect(Timer.side_for('Fold over left', 'Reclining Twist - right side')).to eq('left')
    expect(Timer.side_for('Add twisting halfway through', 'Sphinx')).to be_nil
  end

  it 'appends positions and orders the session by them' do
    a = create(:timer, session: session, title: 'A')
    b = create(:timer, session: session, title: 'B', instruction: 'Fold over left')
    expect([a.position, b.position]).to eq([1, 2])
    expect(b.side).to eq('left')
    b.update!(position: 0)
    expect(session.reload.timers).to eq([b, a])
  end

  it 'keeps an explicit kind' do
    expect(create(:timer, title: 'Meditation', kind: 'counterpose').kind).to eq('counterpose')
  end
end
