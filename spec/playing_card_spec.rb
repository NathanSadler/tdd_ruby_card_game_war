require_relative '../lib/playing_card'

describe 'PlayingCard' do
  context 'class' do
    it 'has a set of valid ranks' do
      expect((PlayingCard::RANKS)).to match_array %w(A 2 3 4 5 6 7 8 9 10 J Q K)
    end
  end

  it 'has a valid rank' do
    expect(PlayingCard::RANKS.include?(PlayingCard.new("A").rank)).to be true
  end

  it('creates a card with a specific rank') do
    card = PlayingCard.new("5")
    expect(card.rank).to eq("5")
  end
end
