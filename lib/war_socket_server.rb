require_relative 'war_game'
require 'socket'

class WarSocketServer

  attr_reader :players

  def initialize
    @players = []
  end

  def port_number
    3336
  end

  def games
    @games ||= []
  end

  def start
    @server = TCPServer.new(port_number)
  end

  def accept_new_client(player_name = "Random Player")
    client = @server.accept_nonblock
    @players.push({:client => client, :name => player_name})
    # associate player and client
  rescue IO::WaitReadable, Errno::EINTR
    puts "No client to accept"
  end

  def create_game_if_possible
    # Check how many clients there are (there need to be 2)
    if @players.length == 2
      games.push(WarGame.new("Player 1", "Player 2"))
    end
  end

  def stop
    @server.close if @server
  end
end
