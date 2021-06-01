require_relative '../lib/card_deck'
require_relative '../lib/playing_card'

describe 'CardDeck' do
  let(:deck) {CardDeck.new}
  it 'Should have 52 cards when created' do
    deck = CardDeck.new
    expect(deck.cards_left).to eq 52
  end

  it 'should deal the top card' do
    card = deck.deal
    expect(card).to eq(PlayingCard.new("A"))
    expect(deck.cards_left).to eq 51
  end

  it 'creates an unshuffled deck of cards' do
    [PlayingCard.new("A"), PlayingCard.new("2"),
      PlayingCard.new("3")].each do |card|
        expect(deck.deal).to eq(card)
      end
  end

  it 'shuffles a deck of cards' do
    # With a seed of 1, the first card's rank should be 6
    deck.shuffle(1)
    first_card = deck.deal
    expect(first_card).to_not eq(PlayingCard.new("A"))
    expect(first_card).to eq(PlayingCard.new("6"))
  end
end
