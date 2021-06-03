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

  describe('.set_active_card') do
    it("changes the player's active card") do
      new_card = PlayingCard.new("4", "H")
      player.set_active_card(new_card)
      expect(player.active_card).to(eq(new_card))
    end
    it("changes the player's active card to the last element if it takes an array") do
      cards = [PlayingCard.new("2", "S"), PlayingCard.new("3", "S")]
      player.set_active_card(cards)
      expect(player.active_card).to(eq(PlayingCard.new("3", "S")))
    end
  end

  describe('.draw_card') do
    it('removes the card at the top of the deck and returns it') do
      player.take_card(PlayingCard.new("4", "H"))
      expect(player.draw_card).to eq(PlayingCard.new("4", "H"))
    end
    it("changes the player's card to whatever card got drawn") do
      new_card = PlayingCard.new("4", "H")
      player.take_card(new_card)
      player.draw_card
      expect(player.active_card).to(eq(new_card))
    end

    describe('.has_card?') do
      let(:test_card) {PlayingCard.new("3", "D")}
      it('is true if the player has the specified card') do
        player.take_card(test_card)
        expect(player.has_card?(test_card)).to(eq(true))
      end
      it('is false if the player does not has the specified card') do
        expect(player.has_card?(test_card)).to(eq(false))
      end
    end

    describe('.clear_deck') do
      it("removes all cards from the player's deck") do
        player.take_card(PlayingCard.new("4", "S"))
        player.clear_deck
        expect(player.card_count).to(eq(0))
      end
    end

    it("changes the player's card to the last card drawn if multiple cards are" +
    " drawn") do
      new_cards = [PlayingCard.new("4", "H"), PlayingCard.new("5", "H"),
        PlayingCard.new("6", "H")]
      new_cards.map {|card| player.take_card(card)}
      player.draw_card(3)
      expect(player.active_card).to(eq(PlayingCard.new("6", "H")))
    end

    it("doesn't change the active card if there are no cards to draw") do
      test_card = PlayingCard.new("2", "D")
      player.take_card(test_card)
      2.times {player.draw_card}
      expect(player.active_card).to(eq(test_card))
    end
  end

  it('returns the name of the player') do
    expect(player.name).to eq("John Doe")
  end

end
