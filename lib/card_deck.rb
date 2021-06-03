require_relative('playing_card')

class CardDeck
  def initialize(custom_cards=nil)
    @card_list = []
    if custom_cards.nil?
      @card_list = CardDeck.generate_array_with_all_cards
    else
      custom_cards.each do |i|
        @card_list.push(i)
      end
    end
  end

  def self.generate_array_with_all_cards
    card_list = []
    PlayingCard::SUITS.each do |suit|
      PlayingCard::RANKS.each do |rank|
        card_list.push(PlayingCard.new(rank, suit))
      end
    end
    card_list
  end

  def has_card?(card_to_find)
    @card_list.include?(card_to_find)
  end

  def cards_left
    @card_list.length
  end

  def draw(count = nil)
    if(!count || count == 1)
      returned_cards = @card_list.shift
    else
      returned_cards = @card_list.shift(count)
    end
    @cards_left = @card_list.length
    returned_cards
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
