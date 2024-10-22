# Gleam Gun

Gleam bindings to [gun][gun], the Erlang HTTP/1.1, HTTP/2 and Websocket client.

Fork of [nerf](https://github.com/lpil/nerf) that adds connection options.

[gun]: https://hex.pm/packages/gun 

Currently this library is very basic and only supports a portion of the
websocket API, and TLS is not verified! Hopefully in future a better websocket
client written in Gleam can replace this one.

## Usage

This package can be added to your Gleam project like so.

```sh
gleam add gleam_gun
```

Then use it in your Gleam application.

```rust
import gleam/erlang/atom
import gleam_gun/websocket.{Text}

pub fn main() {
  // Set connection options
  let conn_opts = [
    websocket.Transport(atom.create_from_string("tls")),
    websocket.TransportOptions([websocket.Verify(atom.create_from_string("verify_none"))]),
  ]
  // Connect
  let assert Ok(conn) = websocket.connect("example.com", "/ws", 8080, [], conn_opts)

  // Send some messages
  websocket.send(conn, "Hello")
  websocket.send(conn, "World")

  // Receive some messages
  let assert Ok(Text("Hello")) = websocket.receive(conn, 500)
  let assert Ok(Text("World")) = websocket.receive(conn, 500)

  // Close the connection
  websocket.close(conn)
}
```

## Testing this library

```sh
podman run --rm --detach -p 8080:8080 --name echo jmalloc/echo-server
gleam test
```
