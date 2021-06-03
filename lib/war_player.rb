 class WarPlayer
   attr_reader :active_card

   def initialize(name = nil)
     @player_deck = CardDeck.new
     @player_deck.clear
     @name = name
     @active_card = nil
   end

   def card_count
     return @player_deck.cards_left
   end

   def take_card(new_card)
     @player_deck.add_card(new_card)
   end

   def set_active_card(new_card)
     @active_card = new_card
   end

   def draw_card(card_count=1)
     @player_deck.draw(card_count)
   end

   def name
     @name
   end

 end
