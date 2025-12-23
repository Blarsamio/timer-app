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
