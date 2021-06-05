class WarSocketClient
  attr_reader :socket
  attr_accessor :output, :previous_message

  def initialize(port)
    @socket = TCPSocket.new('localhost', port)
  end

  def provide_input(text)
    socket.puts(text)
  end

  def get_socket
    return @socket
  end

  def display_updated_message(message=capture_output)
    puts(message)
      previous_message = message
  end

  def capture_output(delay=0.1)
    sleep(delay)
    output = socket.read_nonblock(1000) # not gets which blocks
  rescue IO::WaitReadable
    @output = ""
  end

  def close
    socket.close if socket
  end

end
