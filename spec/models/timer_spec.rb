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
