require_relative '../lib/war_player'
require_relative '../lib/playing_card'

describe 'WarPlayer' do
  let(:player) {WarPlayer.new}
  it('starts without any cards') do
    expect(player.card_count).to eq(0)
  end
end
