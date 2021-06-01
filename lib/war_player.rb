 class WarPlayer
   def initialize(name = nil)
     @player_deck = CardDeck.new
     @player_deck.clear
     @name = name
   end

   def card_count
     return @player_deck.cards_left
   end

   def take_card(new_card)
     @player_deck.add_card(new_card)
   end

   def draw_card
     @player_deck.draw
   end

   def name
     @name
   end

 end
