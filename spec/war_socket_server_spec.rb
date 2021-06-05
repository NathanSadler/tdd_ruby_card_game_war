require 'socket'
require_relative '../lib/war_socket_server'
require_relative '../lib/war_socket_client'
require_relative '../lib/playing_card'

# Remember, this is just for testing.
def connect_client(server, player_name, client_list)
  client = WarSocketClient.new(server.port_number)
  client_list.push(client)
  server.accept_new_client(player_name, client)
end

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

  describe('set_player_game_id') do
    it("sets the game id of one of it's players") do
      @server.start
      connect_client(@server, "player name", @clients)
      @server.set_player_game_id(0, 1)
      expect(@server.players[0][:game_id]).to(eq(1))
    end
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
    expect(@clients[0].capture_output.include?("Hello World")).to(eq(true))
    expect(@clients[1].capture_output.include?("Hello World")).to(eq(true))
  end

  describe("send_message_to_players_in_game") do
    it('sends a message to the players in a game') do
      @server.start
      2.times{ connect_client(@server,"b", @clients)}
      @server.create_game_if_possible
      connect_client(@server, "3", @clients)
      @server.send_message_to_players_in_game(0, "this is just for you")
      expect(@clients[0].capture_output.include?("this is just for you")).to(eq(true))
      expect(@clients[2].capture_output.include?("this is just for you")).to(eq(false))
    end
  end

  describe("accept_new_client") do
    it("adds a waiting client to its list of players") do
      @server.start
      connect_client(@server, "foobar", @clients)
      expect(@server.players.length).to(eq(1))
    end
  end

  describe("create_game_if_possible") do
    it("creates a game when there are two unmatched players") do
      @server.start
      2.times {connect_client(@server, "foobar", @clients)}
      @server.create_game_if_possible
      expect(@server.games.length).to(eq(1))
    end
  end

  # Add more tests to make sure the game is being played
  # For example:
  #   make sure the mock client gets appropriate output
  #   make sure the next round isn't played until both clients say they are ready to play
  #   ...
  describe('.play_round') do
    before(:each) do
      @server.start
      ["Player 1", "Player 2"].each {|player_name| connect_client(@server, player_name, @clients)}
      @server.create_game_if_possible
    end
    it('plays a round when both players are ready') do
      # server, player_name, client_list
      @clients[0].provide_input("ready")
      @clients[1].provide_input("ready")
      @server.play_round
      expect(@clients[0].capture_output.include?(" won ")).to(eq(true))
    end

    it("doesn't play a round for games other than the one that was specified") do
      2.times {connect_client(@server, "test_name", @clients)}
      @server.create_game_if_possible
      @clients[0].provide_input("ready")
      @clients[1].provide_input("ready")
      @server.play_round
      expect(@clients[0].capture_output.include?(" won ")).to(eq(true))
      expect(@server.games[1].player1.card_count).to(eq(26))
    end

  end

  describe('list_players_in_game') do
    before(:each) do
      @server.start
      ["Player 1", "Player 2"].each {|player_name| connect_client(@server, player_name, @clients)}
      @server.create_game_if_possible
    end
    it('returns an array of each player in the game with game_id') do
      connect_client(@server, "test_name", @clients)
      @server.create_game_if_possible
      test_results = @server.list_players_in_game(0).map {|player| player[:war_socket]}
      expect(test_results.include?(@clients[0])).to(eq(true))
    end
  end
end
