require_relative('card_deck')
require_relative('war_player')
class WarGame
  attr_accessor :player1, :player2
  def initialize(player_1_name=nil, player_2_name=nil, custom_deck=nil)
    starting_deck = CardDeck.new(custom_deck)
    starting_deck.shuffle
    @player1 = WarPlayer.new(player_1_name)
    @player2 = WarPlayer.new(player_2_name)
    (starting_deck.cards_left / 2).times do
      @player1.take_card(starting_deck.draw)
      @player2.take_card(starting_deck.draw)
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

  def self.get_round_results(winning_player, winner_active_card, cards_at_stake)
    formatted_cards_at_stake = cards_at_stake.map(&:description)
    if cards_at_stake.length == 2
      spoils_of_war = formatted_cards_at_stake.join(" and ")
    else
      # Add 'and' between last comma and last card in spoils_of_war
      spoils_of_war = formatted_cards_at_stake.join(", ")
      spoils_match = spoils_of_war.match(',[^,]+$')
      spoils_of_war = "#{spoils_match.pre_match}, and #{formatted_cards_at_stake[-1]}"
    end
    return("#{winning_player.name} wins #{spoils_of_war} with "+
    "#{winner_active_card.description}.")
  end

  def self.subtract_card_values(card_1, card_2)
    values =
    {
      "A" => 1,
      "J" => 11,
      "Q" => 12,
      "K" => 13
    }
    (2..10).each do |number|
      values.store(number.to_s, number)
    end
    values[card_1.rank] - values[card_2.rank]
  end

  def play_round
    p1_active_card = PlayingCard.new("2", "S")
    p2_active_card = PlayingCard.new("2", "S")
    cards_at_stake = []
    round_winner = ""
    round_winner_card = ""
    while p1_active_card.rank == p2_active_card.rank
      if(player1.card_count > 0)
        p1_active_card = self.player1.draw_card
      end
      if(player2.card_count > 0)
        p2_active_card = self.player2.draw_card
      end
      cards_at_stake.append(p1_active_card, p2_active_card)
      # Randomizes order of cards_at_stake to avoid infinite loops... somehow
      cards_at_stake.shuffle!

      if WarGame.subtract_card_values(p1_active_card, p2_active_card) > 0
        cards_at_stake.map {|card| self.player1.take_card(card)}
        round_winner = player1
        round_winner_card = p1_active_card
      elsif WarGame.subtract_card_values(p1_active_card, p2_active_card) < 0
        cards_at_stake.map {|card| self.player2.take_card(card)}
        round_winner = player2
        round_winner_card = p2_active_card
      else
        # Adds cards from a war to cards_at_stake
        drawn_cards = []
        if self.player1.card_count >= 4
          self.player1.draw_card(3).map {|card| drawn_cards.push(card)}
        elsif self.player1.card_count > 0
          (self.player1.card_count - 1).times {drawn_cards.push(player1.draw_card)}
        end
        if self.player2.card_count >= 4
          self.player2.draw_card(3).map {|card| drawn_cards.push(card)}
        elsif self.player2.card_count > 0
          (self.player2.card_count - 1).times {|card| drawn_cards.push(player2.draw_card)}
        end
        drawn_cards.map {|card| cards_at_stake.push(card)}
      end
    end
    # Prints which player won what cards this round
    puts(WarGame.get_round_results(round_winner, round_winner_card, cards_at_stake))

  end

end
