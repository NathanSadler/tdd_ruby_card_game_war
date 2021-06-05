require_relative 'war_socket_client'
require 'socket'

war_client = WarSocketClient.new(3336)
previous_message = ""

while true
  new_message = war_client.capture_output
  if (!new_message.nil? && new_message != previous_message)
    # Display the most recent message if it is not equal to the previous one
    puts(new_message)
  end

  previous_message = new_message

  # Let user input something if new_message promps the user for an input
  if (!new_message.include?("enter"))
    user_input = gets
    war_client.provide_input(user_input)
  end

end
