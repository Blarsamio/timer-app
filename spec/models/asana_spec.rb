require 'rails_helper'

RSpec.describe Asana, type: :model do
  describe 'factories' do
    it 'has a valid factory' do
      expect(build(:asana)).to be_valid
    end
  end

  describe '#duration_in_seconds' do
    {
      'Three to five minutes.' => 240,
      'Two to three minutes per side.' => 150,
      'Five to ten minutes.' => 450,
      '3-5 min' => 240,
      '4 minutes' => 240,
      '30-60 seconds' => 45,
      'whenever' => nil
    }.each do |text, expected|
      it "parses #{text.inspect} as #{expected.inspect}" do
        expect(build(:asana, recommended_time: text).duration_in_seconds).to eq(expected)
      end
    end
  end

  describe '.match_title' do
    it 'maps flow names to library asanas, most specific first' do
      straddle = create(:asana, title: 'Straddle (Dragonfly)')
      half = create(:asana, title: 'Half Butterfly')
      create(:asana, title: 'Butterfly')

      expect(Asana.match_title('Straddle with side-bend (left)')).to eq(straddle)
      expect(Asana.match_title('Half Butterfly: fold over left leg')).to eq(half)
      expect(Asana.match_title('Opening Meditation')).to be_nil
    end
  end

  describe '.by_title' do
    it 'searches case-insensitively' do
      swan = create(:asana, title: 'Swan & Sleeping Swan')
      expect(Asana.by_title('sleeping')).to eq([swan])
    end
  end
end
