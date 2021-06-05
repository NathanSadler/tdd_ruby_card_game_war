require_relative 'war_socket_server'

server = WarSocketServer.new()
server.start
while true
  server.accept_new_client
  if server.create_game_if_possible
    game_id = server.games.length - 1
    Thread.new(game_id) {|game_id| server.play_full_game(game_id)}
  end
end
