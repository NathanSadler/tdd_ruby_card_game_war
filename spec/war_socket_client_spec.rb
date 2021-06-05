require 'socket'
require_relative '../lib/war_socket_server'
require_relative '../lib/war_socket_client'
require_relative '../lib/playing_card'

def connect_client(server, player_name, client_list)
  client = WarSocketClient.new(server.port_number)
  client_list.push(client)
  server.accept_new_client(player_name, client)
end

describe WarSocketClient do
  before(:each) do
    @server = WarSocketServer.new
    @clients = []
    @server.start
  end

  after(:each) do
    @server.stop
    @clients.each do |client|
    end
  end

  describe('.display_updated_message') do
    it('outputs a message it recieves from the server') do
      connect_client(@server, "Player Name", @clients)
      @server.send_message_to_all_clients("Hello World")
      expect{@clients[0].display_updated_message}.to output(/Hello World/).to_stdout
    end
  end

end
