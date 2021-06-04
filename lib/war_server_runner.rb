require_relative 'war_socket_server'

server = WarSocketServer.new()
server.start
while server.games.count != 1
  server.accept_new_client
  server.create_game_if_possible
end
puts "game started"
#server.create_game_if_possible
server.play_full_game(0)
