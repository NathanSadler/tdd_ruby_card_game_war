require('playing_card')

class CardDeck
  def initialize
    @card_list = []
    4.times do
      PlayingCard::RANKS.each do |i|
        @card_list.push(PlayingCard.new(i))
      end
    end
  end

  def cards_left
    @card_list.length
  end

  def deal
    returned_card = @card_list.shift
    @cards_left = @card_list.length
    returned_card
  end

  def shuffle(seed=nil)
    if !seed
      @card_list.shuffle!
    else
      @card_list.shuffle!(random: Random.new(seed))
    end
  end

end
