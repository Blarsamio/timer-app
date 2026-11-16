require 'rails_helper'

RSpec.describe Asana, type: :model do
  describe 'factories' do
    it 'has a valid factory' do
      expect(build(:asana)).to be_valid
    end
  end

  describe 'timing' do
    {
      'Three to five minutes.' => [180, 300, 240],
      'Two to three minutes per side.' => [120, 180, 150],
      'About one minute per side, mainly as a counterpose.' => [60, 60, 60],
      'Three to five minutes per side, or one minute per variation.' => [180, 300, 240],
      '3-5 min' => [180, 300, 240],
      '30-60 seconds' => [30, 60, 45],
      'whenever' => [nil, nil, nil]
    }.each do |text, expected|
      it "derives #{expected.inspect} from #{text.inspect} on save" do
        asana = create(:asana, recommended_time: text)
        expect(asana.values_at(:min_seconds, :max_seconds, :default_seconds)).to eq(expected)
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
