require 'rails_helper'

RSpec.describe Session, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'associations' do
    it { should have_many(:timers).dependent(:destroy) }
    it { should have_many(:asanas) }
  end
end
