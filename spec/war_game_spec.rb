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

  describe('.add_to_stakes') do
    it('adds a single card to the stakes') do
      card = PlayingCard.new("9", "C")
      game.add_to_stakes(card)
      expect(game.cards_at_stake).to(eq([card]))
    end
    it('adds several cards to the stakes') do
      cards = [PlayingCard.new("9", "C"), PlayingCard.new("10", "C")]
      game.add_to_stakes(cards)
      expect(game.cards_at_stake).to(eq(cards))
    end
  end

  describe('.award_cards') do
    it('gives cards to the player with a higher-rank active card') do
      game.player1.clear_deck
      cards_at_stake = [PlayingCard.new("2", "D"), PlayingCard.new("3", "D")]
      game.player1.set_active_card(PlayingCard.new("K", "D"))
      game.player2.set_active_card(PlayingCard.new("2", "D"))
      game.award_cards(cards_at_stake)
      player_1_cards = game.player1.draw_card(2)
      (["2", "3"].map {|rank| PlayingCard.new(rank, "D")}).each {|card| expect(player_1_cards.include?(card)).to(eq(true))}
    end
  end

  describe('.deal_cards') do
    it("equally deals cards between the two players") do
      [game.player1, game.player2].each {|player| player.clear_deck}
      starting_cards = [2, 3, 4, 5, 6, 7].map {|rank| PlayingCard.new(rank, "H")}
      game.deal_cards(CardDeck.new(starting_cards))
      [game.player1, game.player2].each {|player| expect(player.card_count).to(eq(3))}
      # Makes sure player 1 has the 2, 4, and 6 of hearts
      ([2, 4, 6].map {|rank| PlayingCard.new(rank, "H")}).each {|card| expect(
        game.player1.has_card?(card)).to(eq(true))}
    end
  end

  describe('.declare_war') do
    before(:each) do
      @test_game = WarGame.new("John Doe", "Jane Doe")
      # Clears all cards from both players
      [@test_game.player1, @test_game.player2].each {|player| player.clear_deck}
    end
    it('gives the player that wins a war all of the cards being played') do
      ["2", "3", "4", "5", "6"].map {|rank| @test_game.player1.take_card(PlayingCard.new(rank, "S"))}
      ["2", "3", "4", "5", "K"].map {|rank| @test_game.player2.take_card(PlayingCard.new(rank, "H"))}
      @test_game.declare_war
      expect(@test_game.player1.card_count).to(eq(0))
      expect(@test_game.player2.card_count).to(eq(10))
    end
    it('can declare war multiple times in a row') do
      ["2", "3", "4", "5", "6", "7", "8", "9", "10"].map {|rank| @test_game.player1.take_card(PlayingCard.new(rank, "S"))}
      ["2", "3", "4", "5", "6", "7", "8", "9", "K"].map {|rank| @test_game.player2.take_card(PlayingCard.new(rank, "H"))}
      @test_game.declare_war
      expect(@test_game.player1.card_count).to(eq(0))
      expect(@test_game.player2.card_count).to(eq(18))
    end
  end

  describe('.get_player_with_higher_rank_active_card') do
    it('returns the player with the higher ranking active card') do
      game.player1.set_active_card(PlayingCard.new("K", "C"))
      game.player2.set_active_card(PlayingCard.new("2", "H"))
      expect(game.get_player_with_higher_rank_active_card).to(eq(game.player1))
    end
    it("returns nil if the rank of both players' cards are equal") do
      game.player1.set_active_card(PlayingCard.new("K", "C"))
      game.player2.set_active_card(PlayingCard.new("K", "H"))
      expect(game.get_player_with_higher_rank_active_card).to(eq(nil))
    end
  end

  describe('#subtract_card_values') do
    before(:all) do
      @card_a = PlayingCard.new("2", "C")
      @card_b = PlayingCard.new("10", "H")
    end
    it('returns a positive number if card_1 has a greater value than card_2') do
      expect(WarGame.subtract_card_values(@card_b, @card_a) > 0).to eq(true)
    end
    it('returns a negative number if card_2 has a greater value than card_1') do
      expect(WarGame.subtract_card_values(@card_a, @card_b) < 0).to eq(true)
    end
    it('returns 0 if both cards have the same value') do
      expect(WarGame.subtract_card_values(@card_a, PlayingCard.new("2", "D"))).to eq(0)
    end
    it('treats aces as the lowest value card') do
      expect(WarGame.subtract_card_values(PlayingCard.new("A", "S"), @card_a) < 0).to eq(true)
    end
  end

  describe('#get_round_results') do
    before(:each) do
      @test_game = WarGame.new("John Doe", "Jane Doe")
      # Clears all cards from both players
      player1_card_count = @test_game.player1.card_count
      player2_card_count = @test_game.player2.card_count
      player1_card_count.times {@test_game.player1.draw_card}
      player2_card_count.times {@test_game.player2.draw_card}
    end
    it('returns a string that describes the result of a round with specified' +
      ' cards at stake, p1 active card, and p2 active card') do
      king_card = PlayingCard.new("K", "S")
      two_card = PlayingCard.new("2", "S")
      cards_at_stake = [king_card, two_card]
      winner_active_card = king_card
      round_message = WarGame.get_round_results(@test_game.player1,
        winner_active_card, cards_at_stake)
      expect(round_message).to(eq("John Doe wins King of Spades and 2 of Spades"+
        " with King of Spades."))
    end

    it('returns a message in the format <winner name> wins <card1>, <card2>, '+
    "..., and <cardn> with <winner_active_card>") do
      cards_at_stake = []
      ["1", "2", "3", "K"].map { |rank| cards_at_stake.push(PlayingCard.new(rank, "H"))}
      winner_active_card = PlayingCard.new("K", "H")
      round_message = WarGame.get_round_results(@test_game.player2,
        winner_active_card, cards_at_stake)
      expect(round_message).to(eq("Jane Doe wins 1 of Hearts, 2 of Hearts, 3 of"+
          " Hearts, and King of Hearts with King of Hearts."))
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
      @test_game.player1.take_card(PlayingCard.new("K", "S"))
      @test_game.player2.take_card(PlayingCard.new("2", "S"))
      @test_game.play_round
      expect(@test_game.player1.card_count).to(eq(2))
      expect(@test_game.player2.card_count).to(eq(0))
      expect(test_results.include?(PlayingCard.new("K", "S"))).to(eq(true))
      expect(test_results.include?(PlayingCard.new("2", "S"))).to(eq(true))
    end

    it('declares war even if one of the players has less than 4 cards') do
      ["2", "3", "4", "5", "6"].map {|rank| @test_game.player1.take_card(PlayingCard.new(rank, "S"))}
      ["2", "3", "4", "5"].map {|rank| @test_game.player2.take_card(PlayingCard.new(rank, "H"))}
      @test_game.play_round
      expect(@test_game.player1.card_count).to(eq(9))
      expect(@test_game.player2.card_count).to(eq(0))
    end
  end

end
