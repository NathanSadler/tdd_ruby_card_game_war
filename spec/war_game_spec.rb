require_relative '../lib/war_game'

describe 'WarGame' do
  let(:game) {WarGame.new}
  it('creates two players with different 26-card decks') do
    player1 = game.player1
    player2 = game.player2
    expect(player1.draw_card != player2.draw_card).to eq(true)
    expect(player1.card_count).to eq(player2.card_count)
  end
end
