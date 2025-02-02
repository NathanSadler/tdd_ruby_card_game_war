 class WarPlayer
   attr_reader :active_card

   def initialize(name = nil)
     @player_deck = CardDeck.new
     @player_deck.clear
     @name = name
     @active_card = PlayingCard.new("0", "D")
   end

   def card_count
     return @player_deck.cards_left
   end

   def take_card(new_card)
     @player_deck.add_card(new_card)
   end

   def set_active_card(new_card)
     if !new_card.nil?
       if !new_card.is_a?(Array)
         new_card = [new_card]
       end
       @active_card = new_card[-1]
     end
   end

   def clear_deck
     @player_deck.clear
   end

   def take_multiple_cards(cards)
     cards.each do |card|
       take_card(card)
     end
   end

   def draw_card(card_count=1)
     drawn = @player_deck.draw(card_count)
     set_active_card(drawn)
     drawn
   end

   def has_card?(card_to_find)
     @player_deck.has_card?(card_to_find)
   end

   def name
     @name
   end

 end
