require_relative 'war_socket_server'

server = WarSocketServer.new()
server.start
while true
  server.accept_new_client
  #game = server.create_game_if_possible
  server.create_game_if_possible
end
puts "game started"
server.players[0].puts "Testing"
