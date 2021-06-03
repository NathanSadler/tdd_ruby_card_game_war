require_relative '../lib/card_deck'
require_relative '../lib/playing_card'
require_relative '../lib/war_player'

describe 'CardDeck' do
  let(:deck) {CardDeck.new}

  it 'Should have 52 cards when created' do
    deck = CardDeck.new
    expect(deck.cards_left).to eq 52
  end

  describe('#generate_array_with_all_cards') do
    it('generates an array that contains each card') do
      cards_to_test = [PlayingCard.new("2", "D"), PlayingCard.new("7", "H"),
      PlayingCard.new("Q", "S"), PlayingCard.new("A", "C")]
      all_cards = CardDeck.generate_array_with_all_cards
      expect(all_cards.length).to(eq(52))
      cards_to_test.each {|card| expect(all_cards.include?(card)).to(eq(true))}
    end
  end

  it 'should draw the top card' do
    card = deck.draw
    expect(card).to eq(PlayingCard.new("A", "C"))
    expect(deck.cards_left).to eq 51
  end

  it 'can take multiple cards from the top' do
    cards = deck.draw(2)
    expect(cards).to eq([PlayingCard.new("A", "C"), PlayingCard.new("2", "C")])
  end

  it 'creates an unshuffled deck of cards' do
    [PlayingCard.new("A", "C"), PlayingCard.new("2", "C"),
      PlayingCard.new("3", "C")].each do |card|
        expect(deck.draw).to eq(card)
      end
  end

  it 'creates a deck with specific cards if cards are specified' do
    custom_cards = [PlayingCard.new("3", "S"), PlayingCard.new("4", "S")]
    test_deck = CardDeck.new(custom_cards)
    expect(test_deck.draw).to eq(PlayingCard.new("3", "S"))
  end

  it 'shuffles a deck of cards' do
    expect(deck.shuffle.eql?(CardDeck.new.shuffle)).to eq(false), "there is a chance this is a false negative. Try again"
  end

  describe('.is_empty?') do
    it('is false if there are cards in the deck') do
      expect(CardDeck.new.is_empty?).to eq(false)
    end
    it('is true if there are no cards in the deck') do
      deck_to_empty = CardDeck.new
      52.times {deck_to_empty.draw}
    end
  end

  it 'removes all cards from itself' do
    deck.clear
    expect(deck.is_empty?).to eq(true)
  end

  it 'adds a card to the bottom of the deck' do
    deck.add_card(PlayingCard.new("6", "S"))
    52.times {deck.draw}
    expect(deck.draw.rank).to eq("6")
  end

  describe('.has_card?') do
    let(:player) {WarPlayer.new}
    let(:test_card) {PlayingCard.new("3", "D")}
    it('is true if the player has the specified card') do
      deck.cards_left.times {deck.draw}
      deck.add_card(test_card)
      expect(deck.has_card?(test_card)).to(eq(true))
    end
    it('is false if the player does not has the specified card') do
      deck.clear
      expect(deck.has_card?(test_card)).to(eq(false))
    end
  end
end
