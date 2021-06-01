class WarGame
  attr_accessor :player1, :player2
  def initialize
    starting_deck = CardDeck.new
    starting_deck.shuffle
    @player1 = WarPlayer.new
    @player2 = WarPlayer.new
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

end
