require_relative '../lib/war_player'
require_relative '../lib/playing_card'

describe 'WarPlayer' do
  let(:player) {WarPlayer.new}
  it('starts without any cards') do
    expect(player.card_count).to eq(0)
  end

  it('takes a card and adds it to the bottom of the deck') do
    player.take_card(PlayingCard.new("2", "H"))
    player.take_card(PlayingCard.new("3", "H"))
    expect(player.draw_card).to eq(PlayingCard.new("2", "H"))
  end

  it('removes the card at the top of the deck and returns it') do
    drawn_card = player.draw_card
    player.take_card(PlayingCard.new("4", "H"))
    expect(player.draw_card).to eq(PlayingCard.new("4", "H"))
  end

end
