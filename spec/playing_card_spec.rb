require_relative '../lib/playing_card'

describe 'PlayingCard' do
  context 'class' do
    it 'has a set of valid ranks' do
      expect((PlayingCard::RANKS)).to match_array %w(A 2 3 4 5 6 7 8 9 10 J Q K)
    end
  end

  it 'has a valid rank' do
    expect(PlayingCard::RANKS.include?(PlayingCard.new("A", "H").rank)).to eq(true)
  end

  it("returns the card's rank") do
    card = PlayingCard.new("9", "C")
    expect(card.rank).to eq("9")
  end

  it("returns the card's suit") do
    card = PlayingCard.new("9", "S")
    expect(card.suit).to eq("S")
  end

  it('creates a card with a specific rank') do
    card = PlayingCard.new("5", "H")
    expect(card.rank).to eq("5")
  end

  describe('#==') do
    before(:all) do
      @card_a = PlayingCard.new("A", "C")
    end
    it('returns true if both cards have the same rank and suit') do
      expect(@card_a == PlayingCard.new("A", "C")).to eq(true)
    end
    it('returns true if the cards have different ranks') do
      expect(@card_a == PlayingCard.new("4", "D")).to eq(false)
    end
  end

end
