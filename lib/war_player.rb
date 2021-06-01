 class WarPlayer
   def initialize
     @player_deck = CardDeck.new
     @player_deck.clear
   end

   def card_count
     return @player_deck.cards_left
   end

   def take_card
   end

   def draw_card
   end

 end
