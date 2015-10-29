## Chat Server

This is a chat server implemented with Ruby Sockets.

### Usage

Start the server as follows:

```
$: << "."
require 'chat_server'

chat_server = ChatServer.new(3000)
chat_server.run
```

Server will be waiting for connections from clients.

Start some clients as follows:

```
telnet 0.0.0.0 3000
```

Then on clients, on telnet prompt, you can type any message. You will see that on server and other clients connected.
