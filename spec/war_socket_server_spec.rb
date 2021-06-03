require 'socket'
require_relative '../lib/war_socket_server'
require_relative '../lib/war_socket_client'
require_relative '../lib/playing_card'

# Remember, this is just for testing.
class MockWarSocketClient
  attr_reader :socket
  attr_reader :output

  def initialize(port)
    # Creates new TCPSocket Object
    @socket = TCPSocket.new('localhost', port)
  end

  def provide_input(text)
    # Calls TCPSocket (the @socket) .puts
    @socket.puts(text)
  end

  def capture_output(delay=0.1)
    sleep(delay)
    # From IO
    @output = @socket.read_nonblock(1000) # not gets which blocks
  rescue IO::WaitReadable
    @output = ""
  end

  def close
    @socket.close if @socket
  end
end

describe WarSocketClient do
  before(:each) do
    @server = WarSocketServer.new
    @clients = []
  end

  after(:each) do
    @server.stop
    @clients.each do |client|
    end
  end


end

describe WarSocketServer do
  before(:each) do
    @clients = []
    @server = WarSocketServer.new
  end

  after(:each) do
    @server.stop
    @clients.each do |client|
      client.close
    end
  end

  it "is not listening on a port before it is started"  do
    expect {MockWarSocketClient.new(@server.port_number)}.to raise_error(Errno::ECONNREFUSED)
  end

  it "accepts new clients and starts a game if possible" do
    @server.start
    client1 = MockWarSocketClient.new(@server.port_number)
    @clients.push(client1)
    @server.accept_new_client("Player 1")
    @server.create_game_if_possible
    expect(@server.games.count).to(eq(0))
    client2 = MockWarSocketClient.new(@server.port_number)
    @clients.push(client2)
    @server.accept_new_client("Player 2")
    @server.create_game_if_possible
    expect(@server.games.count).to(eq(1))
  end

  describe('.draw_card_from_player') do
    it('draws a card from the deck of a warplayer') do
      @server.start
      client1 = WarSocketClient.new(@server.port_number)
      @clients.push(client1)
      @server.accept_new_client("Player 1")
      client2 = WarSocketClient.new(@server.port_number)
      @clients.push(client2)
      @server.accept_new_client("Player 2")
      @server.create_game_if_possible
      drawn_card = @server.draw_card_from_player(0)
      expect(drawn_card.is_a?(PlayingCard)).to(eq(true))
    end
  end

  describe('.get_text_from_user') do
    it('gets text input from a specified client') do
      @server.start
      client1 = MockWarSocketClient.new(@server.port_number)
      @clients.push(client1)
      @server.accept_new_client("Player 1")
      client2 = MockWarSocketClient.new(@server.port_number)
      @clients.push(client2)
      @server.accept_new_client("Player 2")

      @clients[0].provide_input("Hello World")
      text_from_client = @server.get_text_from_user(@server.players[0][:client])
      expect(text_from_client.include?("Hello World")).to(eq(true))
    end

    describe('.wait_for_specific_message') do
      it('Waits until it gets a specific message from a user') do
        @server.start
        client1 = WarSocketClient.new(@server.port_number)
        @clients.push(client1)
        @server.accept_new_client("Player 1")
        client1.provide_input("Hello to you to")
        text_from_client = @server.wait_for_specific_message("Hello to you to",
        @server.players[0][:client])
        expect(text_from_client.include?("Hello to you to")).to(eq(true))
      end
    end
  end

  it('sends messages to all clients') do
    @server.start
    client1 = MockWarSocketClient.new(@server.port_number)
    @clients.push(client1)
    @server.accept_new_client("Player 1")
    client2 = MockWarSocketClient.new(@server.port_number)
    @clients.push(client2)
    @server.accept_new_client("Player 2")
    @server.send_message_to_all_clients("Hello World")
    expect(@clients[0].capture_output.include?("Hello World"))
    expect(@clients[1].capture_output.include?("Hello World"))
  end

  # Add more tests to make sure the game is being played
  # For example:
  #   make sure the mock client gets appropriate output
  #   make sure the next round isn't played until both clients say they are ready to play
  #   ...
  describe('.play_round') do
    it('plays a round when both players are ready') do
      @server.start
      client1 = MockWarSocketClient.new(@server.port_number)
      @clients.push(client1)
      @server.accept_new_client("Player 1")
      client2 = MockWarSocketClient.new(@server.port_number)
      @clients.push(client2)
      @server.accept_new_client("Player 2")
      @server.create_game_if_possible
      @clients[0].provide_input("Ready")
      @clients[1].provide_input("Ready")
      @server.play_round
      expect(@clients[0].capture_output.include?(" wins ")).to(eq(true))
    end
  end
end
