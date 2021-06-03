require_relative '../lib/war_player'
require_relative '../lib/playing_card'

describe 'WarPlayer' do
  let(:player) {WarPlayer.new("John Doe")}
  it('starts without any cards') do
    expect(player.card_count).to eq(0)
  end

  it('takes a card and adds it to the bottom of the deck') do
    player.take_card(PlayingCard.new("2", "H"))
    player.take_card(PlayingCard.new("3", "H"))
    expect(player.draw_card).to eq(PlayingCard.new("2", "H"))
  end

  describe('set_active_card') do
    it("changes the player's active card") do
      new_card = PlayingCard.new("4", "H")
      player.set_active_card(new_card)
      expect(player.active_card).to(eq(new_card))
    end
  end

  it('removes the card at the top of the deck and returns it') do
    player.take_card(PlayingCard.new("4", "H"))
    expect(player.draw_card).to eq(PlayingCard.new("4", "H"))
  end

  it('returns the name of the player') do
    expect(player.name).to eq("John Doe")
  end

end
