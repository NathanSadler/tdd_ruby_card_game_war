require_relative 'war_socket_server'

server = WarSocketServer.new()
server.start
while server.games.count != 1
  server.accept_new_client
  server.create_game_if_possible
end
puts "game started"
server.players[0][:client].puts "Testing"
