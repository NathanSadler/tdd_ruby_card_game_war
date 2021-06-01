require('playing_card')

class CardDeck
  def initialize

    @cards_left = 52
  end

  def cards_left
    @cards_left ||=52
  end

  def deal
    @cards_left -= 1
    PlayingCard.new
  end

  def top_card
  end

end
