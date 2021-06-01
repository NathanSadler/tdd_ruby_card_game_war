class WarGame
  attr_reader :player1, :player2
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
end
