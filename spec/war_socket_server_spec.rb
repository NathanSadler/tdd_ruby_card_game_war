require 'socket'
require_relative '../lib/war_socket_server'

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

  describe('.get_text_from_user') do
    it('gets text input from a specified client') do
      @server.start
      client1 = MockWarSocketClient.new(@server.port_number)
      @clients.push(client1)
      @server.accept_new_client("Player 1")
      client2 = MockWarSocketClient.new(@server.port_number)
      @clients.push(client2)
      @server.accept_new_client("Player 2")


      #@server.players[0][:client].puts("Hello World")
      @clients[0].provide_input("Hello World")
      text_from_client = @server.get_text_from_user(@server.players[0][:client])
      expect(text_from_client.include?("Hello World")).to(eq(true))
    end
  end

  # Add more tests to make sure the game is being played
  # For example:
  #   make sure the mock client gets appropriate output
  #   make sure the next round isn't played until both clients say they are ready to play
  #   ...


end
