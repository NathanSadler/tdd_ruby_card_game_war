require_relative 'war_game'

game = WarGame.new("Player 1", "Player 2")
#game.start
until game.winner do
  puts game.play_round
end
puts "Winner: #{game.winner.name}"
