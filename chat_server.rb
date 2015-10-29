require 'socket'

class ChatServer
  def initialize(port)
    @descriptors = []
    @server_socket = TCPServer.new("", port)
    @server_socket.setsockopt(Socket::SOL_SOCKET, Socket::SO_REUSEADDR, 1)
    p "Chat Server started on port #{port}"
    @descriptors << @server_socket
  end

  def run
    while true
      res = select(@descriptors, nil, nil, nil)

      if res != nil
        for sock in res[0]
          if sock == @server_socket
            # we have a read on the server socket
            accept_new_connection
          else
            # we have a read on a client socket
            if sock.eof?
              str = "Client left #{sock.peeraddr[2]}:#{sock.peeraddr[1]}\n"
              broadcast_string str, sock
              sock.close
              @descriptors.delete(sock)
            else
              str = "[#{sock.peeraddr[2]}|#{sock.peeraddr[1]}]: #{sock.gets}"
              broadcast_string(str, sock)
            end
          end
        end
      end
    end
  end

  private

  def broadcast_string(str, omit_sock)
    @descriptors.each do |clisock|
      if clisock != @server_socket && clisock != omit_sock
        clisock.write(str)
      end
    end
    p str
  end

  def accept_new_connection
    newsock = @server_socket.accept
    @descriptors << newsock
    newsock.write("You're connected to the Chat Server\n")
    str = "Client joined #{newsock.peeraddr[2]}:#{newsock.peeraddr[1]}\n"
    broadcast_string str, newsock
  end
end
