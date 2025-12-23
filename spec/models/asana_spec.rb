require 'rails_helper'

RSpec.describe Asana, type: :model do
  describe 'factories' do
    it 'has a valid factory' do
      expect(build(:asana)).to be_valid
    end
  end
end
