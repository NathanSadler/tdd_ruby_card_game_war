require_relative 'war_game'
require 'socket'
require_relative 'war_player'

class WarSocketServer
  @@player_counter
  attr_accessor :players

  def initialize
    @players = []
    @@player_counter = 0
  end

  def port_number
    3336
  end

  def games
    @games ||= []
  end

  def get_game(index)
    return @games[index]
  end

  def start
    @server = TCPServer.new(port_number)
  end

  def accept_new_client(player_name = "Random Player", war_socket=nil)
    client = @server.accept_nonblock
    @players.push({:client => client, :war_socket => war_socket, :id => @@player_counter})
    @@player_counter += 1
    # associate player and client
  rescue IO::WaitReadable, Errno::EINTR
    puts "No client to accept"
  end

  def send_message_to_all_clients(message)
    players.each do |player|
      player[:client].puts(message)
    end
  end

  def send_message_to_players_in_game(game_id, message)
    @players.each do |player|
      if player[:game_id] == game_id
        player[:client].puts(message)
      end
    end
  end

  # Pauses until it gets any text input from a specified client
  def get_text_from_user(client, prompt="")
    sleep(0.1)
    client_input = client.read_nonblock(1000)
    return client_input
  rescue IO::WaitReadable
  end

  def wait_for_specific_message(message, client)
    while true
      text_from_user = get_text_from_user(client)
      if !text_from_user.nil? then text_from_user.chomp! end
      if(text_from_user == message)
        return text_from_user
      end
    end
  end

  def set_player_game_id(player_id, new_game_id)
    selected_player = players.select {|player| player[:id] == player_id}[0]
    selected_player.store(:game_id, new_game_id)
  end

  def list_players_in_game(game_index)
    players_in_game = players.select {|player| player[:game_id] == game_index}
    return players_in_game
  end

  def create_game_if_possible
    # Check how many clients there are (there need to be 2)
    if (games.length < players.length / 2) && ((players.length % 2) == 0) && (!players.empty?)
      games.push(WarGame.new("Player 1", "Player 2"))
      # Assigns players to clients
      players[-1][:war_player] = games[-1].player1
      players[-2][:war_player] = games[-1].player2
      [players[-1][:id], players[-2][:id]].each {|player_id| set_player_game_id(player_id, games.length - 1)}
      true
    end
  end

  # Plays a game until one player wins
  def play_full_game(game_index=0)
    until games[game_index].winner
      play_round(game_index)
    end
  end

  def play_round(game_index = 0)
    # Waits for each player to say 'ready'
    send_message_to_all_clients("enter 'ready' to play the next round")
    list_players_in_game(game_index).each {|player| wait_for_specific_message('ready', player[:client])}

    # Plays the round
    end_of_round_message = games[game_index].play_round

    # Delivers end-of-round message to both players
    send_message_to_players_in_game(game_index, end_of_round_message)
  end

  def draw_card_from_player(id)
    drawn_card = ""
    @players.each do |player|
      if player[:id] == id
        drawn_card = player[:war_player].draw_card
        return drawn_card
      end
    end
  end

  def stop
    @server.close if @server
  end
end
