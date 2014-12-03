(*
 * Copyright (c) 2013,2014 Citrix Systems Inc
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *)

module type EVENTS = sig

  type 'a io

  type port with sexp_of
  (** an identifier for a source of events. Ports are allocated by calls to
      [listen], then exchanged out-of-band (typically by xenstore) and
      finally calls to [connect] creates a channel between the two domains.
      Events are send and received over these channels. *)

  val port_of_string: string -> [ `Ok of port | `Error of string ]
  val string_of_port: port -> string

  type channel with sexp_of
  (** a channel is the connection between two domains and is used to send
      and receive events. *)

  type event with sexp_of
  (** an event notification received from a remote domain. Events contain no
      data and may be coalesced. Domains which are blocked will be woken up
      by an event. *)

  val initial: event
  (** represents an event which 'fired' when the program started *)

  val recv: channel -> event -> event Lwt.t
  (** [recv channel event] blocks until the system receives an event
      newer than [event] on channel [channel]. If an event is received
      while we aren't looking then this will be remembered and the
      next call to [after] will immediately unblock. If the system
      is suspended and then resumed, all event channel bindings are invalidated
      and this function will fail with Generation.Invalid *)

  val send: channel -> unit io
  (** [send channel] sends an event along [channel], to another domain
      which will be woken up *)

  val listen: int -> (port * channel) io
  (** [listen domid] allocates a fresh port and event channel. The port
      may be supplied to [connect] *)

  val connect: int -> port -> channel io
  (** [connect domid port] connects an event channel to [port] on [domid] *)

  val close: channel -> unit io
  (** [close channel] closes this side of an event channel *)
  
  val description: string
  (** Human-readable description suitable for help text or
      a manpage *)
end