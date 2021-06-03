require_relative 'war_game'
require 'socket'
require_relative 'war_player'

class WarSocketServer

  attr_accessor :players

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
    @players.push({:client => client})
    # associate player and client
  rescue IO::WaitReadable, Errno::EINTR
    puts "No client to accept"
  end

  def send_message_to_all_clients(message)
    players.each do |player|
      player[:client].puts(message)
    end
  end

  # Pauses until it gets any text input from a specified client
  def get_text_from_user(client, prompt="")
    sleep(0.1)
    client_input = client.read_nonblock(1000)
    return client_input
  rescue IO::WaitReadable
  end

  def create_game_if_possible
    # Check how many clients there are (there need to be 2)
    if @players.length == 2
      games.push(WarGame.new("Player 1", "Player 2"))
      # Assigns players to clients
      players[0][:war_player] = games[0].player1
      players[1][:war_player] = games[0].player2
    end
  end

  def play_round
    # Waits for each player to give any text input. Any text will do
    @players.map {|player| get_text_from_user(player[:client])}

    # Plays the round
    end_of_round_message = games[0].play_round

    # Delivers end-of-round message to both players
    send_message_to_all_clients(end_of_round_message)
  end

  def stop
    @server.close if @server
  end
end
