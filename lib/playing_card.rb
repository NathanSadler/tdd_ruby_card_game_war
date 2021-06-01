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
    return @rank == other_card.rank
  end


end
