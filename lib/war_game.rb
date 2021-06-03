require_relative('card_deck')
require_relative('war_player')
class WarGame
  attr_accessor :player1, :player2
  attr_reader :cards_at_stake, :previous_round

  def initialize(player_1_name=nil, player_2_name=nil, custom_deck=nil)
    starting_deck = CardDeck.new(custom_deck)
    starting_deck.shuffle
    @player1 = WarPlayer.new(player_1_name)
    @player2 = WarPlayer.new(player_2_name)
    deal_cards(starting_deck)
    @cards_at_stake = []
    @previous_round = {}
  end

  def add_to_stakes(addition_to_stakes)
    if addition_to_stakes.is_a?(Array)
      @cards_at_stake.concat(addition_to_stakes)
    else
      @cards_at_stake.push(addition_to_stakes)
    end
  end

  def get_player_with_higher_rank_active_card
    if(WarGame.subtract_card_values(@player1.active_card, @player2.active_card) > 0)
      return @player1
    elsif(WarGame.subtract_card_values(@player1.active_card, @player2.active_card) < 0)
      return @player2
    else
      return nil
    end
  end

  def update_previous_round_report(winning_player, cards_won, won_with)
    @previous_round[:winning_player] = winning_player
    @previous_round[:cards_won] = cards_won.map(&:description)
    @previous_round[:won_with] = won_with
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

  # Gives the cards in cards_at_stake to the player that has the higher-rank
  # active card
  def award_cards(cards_to_award)
    cards_to_award.shuffle!
    if(WarGame.subtract_card_values(@player1.active_card, @player2.active_card)>0)
      cards_to_award.each {|card| @player1.take_card(card)}
    else
      cards_to_award.each {|card| @player2.take_card(card)}
    end
  end


  def get_previous_round_report_message
  end

  # Assigns a numeric value to each card rank and returns the result of subtracting
  # the first card's value from the second card's value
  def self.subtract_card_values(card_1, card_2)
    values = {"A" => 1, "J" => 11, "Q" => 12, "K" => 13}
    (2..10).each do |number|
      values.store(number.to_s, number)
    end
    values[card_1.rank] - values[card_2.rank]
  end

  def declare_war
    @cards_at_stake = []
    while player1.active_card.rank == player2.active_card.rank
      [player1, player2].each {|player| add_to_stakes(player.draw_card(4))}
    end
    award_cards(@cards_at_stake)
  end

  def play_round

  end

end
