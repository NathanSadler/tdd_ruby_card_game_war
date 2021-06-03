require_relative('card_deck')
require_relative('war_player')
class WarGame
  attr_accessor :player1, :player2
  attr_reader :cards_at_stake

  def initialize(player_1_name=nil, player_2_name=nil, custom_deck=nil)
    starting_deck = CardDeck.new(custom_deck)
    starting_deck.shuffle
    @player1 = WarPlayer.new(player_1_name)
    @player2 = WarPlayer.new(player_2_name)
    deal_cards(starting_deck)
    @cards_at_stake = []
  end

  def add_to_stakes(addition_to_stakes)
    if addition_to_stakes.is_a?(Array)
      @cards_at_stake.concat(addition_to_stakes)
    else
      @cards_at_stake.push(addition_to_stakes)
    end
  end

  def deal_cards(deck)
    (deck.cards_left / 2).times do
      player1.take_card(deck.draw)
      player2.take_card(deck.draw)
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

  def award_cards(cards_to_award, winning_player)
    cards_to_award.shuffle!
    cards_to_award.each {|card| winning_player.take_card(card)}
  end

# Assigns a numeric value to each card rank and returns the result of subtracting
# the first card's value from the second card's value
  def self.get_round_results(winning_player, winner_active_card, cards_at_stake)

  end



  def self.subtract_card_values(card_1, card_2)
    values = {"A" => 1, "J" => 11, "Q" => 12, "K" => 13}
    (2..10).each do |number|
      values.store(number.to_s, number)
    end
    values[card_1.rank] - values[card_2.rank]
  end

  def declare_war
    while player1.active_card.rank == player2.active_card.rank
      [player1, player2].each {|player| player.draw_card(4)}
    end
  end

  def play_round

  end

end
