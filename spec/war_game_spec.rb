require_relative '../lib/war_game'
require_relative '../lib/playing_card'

describe 'WarGame' do
  let(:game) {WarGame.new("John Doe", "Jane Doh")}
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

  describe('#play_round') do
    before(:each) do
      @test_game = WarGame.new("John Doe", "Jane Doe")
      # Clears all cards from both players
      player1_card_count = @test_game.player1.card_count
      player2_card_count = @test_game.player2.card_count
      player1_card_count.times {@test_game.player1.draw_card}
      player2_card_count.times {@test_game.player2.draw_card}
    end

    it('gives the player with a higher rank card the cards at play') do
      king_card = PlayingCard.new("K", "S")
      @test_game.player1.take_card(king_card)
      two_card = PlayingCard.new("2", "S")
      @test_game.player2.take_card(two_card)
      @test_game.play_round
      expect(@test_game.player1.card_count).to(eq(2))
      expect(@test_game.player2.card_count).to(eq(0))
      expect(@test_game.player1.draw_card(2)).to eq([king_card, two_card])
    end

    it('gives the player that wins a war all of the cards being played') do
      ["2", "3", "4", "5", "6"].map {|rank| @test_game.player1.take_card(PlayingCard.new(rank, "S"))}
      ["2", "3", "4", "5", "K"].map {|rank| @test_game.player2.take_card(PlayingCard.new(rank, "H"))}
      @test_game.play_round
      expect(@test_game.player1.card_count).to(eq(0))
      expect(@test_game.player2.card_count).to(eq(10))
    end

    it('declares war even if one of the players has less than 4 cards') do
      ["2", "3", "4", "5", "6"].map {|rank| @test_game.player1.take_card(PlayingCard.new(rank, "S"))}
      ["2", "3", "4", "5"].map {|rank| @test_game.player2.take_card(PlayingCard.new(rank, "H"))}
      @test_game.play_round
      expect(@test_game.player1.card_count).to(eq(9))
      expect(@test_game.player2.card_count).to(eq(0))
    end

    it('can declare war multiple times in a row') do
      ["2", "3", "4", "5", "6", "7", "8", "9", "10"].map {|rank| @test_game.player1.take_card(PlayingCard.new(rank, "S"))}
      ["2", "3", "4", "5", "6", "7", "8", "9", "K"].map {|rank| @test_game.player2.take_card(PlayingCard.new(rank, "H"))}
      @test_game.play_round
      expect(@test_game.player1.card_count).to(eq(0))
      expect(@test_game.player2.card_count).to(eq(18))
    end
  end

end
