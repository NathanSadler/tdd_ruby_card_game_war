require_relative '../lib/war_game'
require_relative '../lib/playing_card'

describe 'WarGame' do
  let(:game) {WarGame.new}
  it('creates two players with different 26-card decks') do
    player1 = game.player1
    player2 = game.player2
    expect(player1.draw_card != player2.draw_card).to eq(true)
    expect(player1.card_count).to eq(player2.card_count)
  end

  describe('#compare_cards') do
    before(:all) do
      @card_a = PlayingCard.new("2", "C")
      @card_b = PlayingCard.new("10", "H")
    end
    it('returns a positive number if card_1 has a greater value than card_2') do
      expect(WarGame.compare_cards(@card_b, @card_a) > 0).to eq(true)
    end
    it('returns a negative number if card_2 has a greater value than card_1') do
      expect(WarGame.compare_cards(@card_a, @card_b) < 0).to eq(true)
    end
    it('returns 0 if both cards have the same value') do
      expect(WarGame.compare_cards(@card_a, PlayingCard.new("2", "D"))).to eq(0)
    end
    it('treats aces as the lowest value card') do
      expect(WarGame.compare_cards(PlayingCard.new("A", "S"), @card_a) < 0).to eq(true)
    end
  end

  describe('#winner') do
    it('is nil if both players have at least one card') do
      expect(game.winner.nil?).to eq(true)
    end
    it('returns the player with more than one card if one of the players has' +
    ' no more cards') do
      game.player2.card_count.times {game.player2.draw_card}
      expect(game.winner).to eq(game.player1)
    end
  end
end
