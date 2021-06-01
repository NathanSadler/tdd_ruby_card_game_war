require('playing_card')

class CardDeck
  def initialize
    @card_list = []
    PlayingCard::SUITS.each do |suit|
      PlayingCard::RANKS.each do |rank|
        @card_list.push(PlayingCard.new(rank, suit))
      end
    end
  end

  def cards_left
    @card_list.length
  end


  def draw
    returned_card = @card_list.shift
    @cards_left = @card_list.length
    returned_card
  end

  def shuffle(seed=nil)
    @card_list.shuffle!
  end

  def is_empty?
    @card_list.length == 0
  end

  def clear
    @card_list = []
  end

  def add_card(new_card)
    @card_list.push(new_card)
  end
end
