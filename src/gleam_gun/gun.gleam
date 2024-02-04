//// Low level bindings to the gun API. You typically do not need to use this.
//// Prefer the other modules in this library.

import gleam/http.{type Header}
import gleam/erlang/charlist.{type Charlist}
import gleam/dynamic.{type Dynamic}
import gleam/string_builder.{type StringBuilder}
import gleam/bit_builder.{type BitBuilder}

pub type StreamReference

pub type ConnectionPid

pub fn open(
  host: String,
  port: Int,
  opts_map: Dynamic,
) -> Result(ConnectionPid, Dynamic) {
  open_erl(charlist.from_string(host), port, opts_map)
}

@external(erlang, "gun", "open")
fn open_erl(c: Charlist, i: Int, d: Dynamic) -> Result(ConnectionPid, Dynamic)

@external(erlang, "gun", "await_up")
pub fn await_up(pid: ConnectionPid) -> Result(Dynamic, Dynamic)

@external(erlang, "gun", "ws_upgrade")
pub fn ws_upgrade(
  pid: ConnectionPid,
  s: String,
  l: List(Header),
) -> StreamReference

pub type Frame {
  Close
  Text(String)
  Binary(BitArray)
  TextBuilder(StringBuilder)
  BinaryBuilder(BitBuilder)
}

type OkAtom

@external(erlang, "ffi", "ws_send_erl")
fn ws_send_erl(pid: ConnectionPid, ref: String, f: Frame) -> OkAtom

pub fn ws_send(pid: ConnectionPid, frame: Frame) -> Nil {
  ws_send_erl(pid, "myRef", frame)
  Nil
}
