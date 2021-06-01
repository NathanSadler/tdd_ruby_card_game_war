class PlayingCard
  SUITS = %w(C D H S)
  RANKS = %w(A 2 3 4 5 6 7 8 9 10 J Q K)

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def rank
    @rank
  end

  def suit
    @suit
  end

  def ==(other_card)
    return (@rank == other_card.rank) && (@suit == other_card.suit)
  end

  def description
    rank_names =
    {
      "A" => "Ace",
      "J" => "Jack",
      "Q" => "Queen",
      "K" => "King"
    }

    suit_names =
    {
      "D" => "Diamonds",
      "S" => "Spades",
      "C" => "Clubs",
      "H" => "Hearts"
    }
    rank = rank_names[@rank] || @rank
    suit = suit_names[@suit]
    return "#{rank} of #{suit}"
  end
end
