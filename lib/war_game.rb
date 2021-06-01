class WarGame
  attr_accessor :player1, :player2
  def initialize(player_1_name=nil, player_2_name=nil, custom_deck=nil)
    starting_deck = CardDeck.new(custom_deck)
    starting_deck.shuffle
    @player1 = WarPlayer.new(player_1_name)
    @player2 = WarPlayer.new(player_2_name)
    (starting_deck.cards_left / 2).times do
      @player1.take_card(starting_deck.draw)
      @player2.take_card(starting_deck.draw)
    end
  end

  def winner
    if (@player1.card_count > 0) && (@player2.card_count > 0)
      return nil
    elsif @player1.card_count > 0
      return @player1
    else
      return @player2
    end
  end

  def self.compare_cards(card_1, card_2)
    values =
    {
      "A" => 1,
      "J" => 11,
      "Q" => 12,
      "K" => 13
    }
    (2..10).each do |number|
      values.store(number.to_s, number)
    end
    values[card_1.rank] - values[card_2.rank]
  end

  def play_round
    p1_active_card = self.player1.draw_card
    p2_active_card = self.player2.draw_card
    cards_at_stake = [p1_active_card, p2_active_card]
    if WarGame.compare_cards(p1_active_card, p2_active_card) > 0
      round_winner = self.player1
    else
      round_winner = self.player2
    end
    cards_at_stake.map {|card| round_winner.take_card(card)  }

  end

end
