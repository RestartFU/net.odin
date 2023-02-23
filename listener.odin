package net

import "bindings"
import "core:strings"
import "core:fmt"

// Listener is a struct that represents a listener to a local address
Listener :: struct {
    sock: bindings.SOCKET,
    local_addr: Addr,
}

// new_listener creates and returns a new Listener struct
new_listener :: proc (sock : bindings.SOCKET, local_addr: Addr) -> (^Listener, bool) {
    if sock == bindings.INVALID_SOCKET {
        return nil, false
    }
    l := new(Listener)
    l.sock = sock
    l.local_addr = local_addr
	
    return l, bindings.listen(sock, 65535) >= 0
}

// accept wait for an incoming connection, and accepts it.
accept :: proc (listener: ^Listener) -> (^Conn, bool) {
    cli: bindings.sockaddr_in
    length := i32(size_of(cli))

    sock := bindings.accept(listener.sock, cast(^bindings.SOCKADDR)&cli, &length)
    if sock == bindings.INVALID_SOCKET {
        return nil, false
    }

    str := bindings.inet_ntoa(cli.sin_addr)
    addr, _ := addr_from_string(strings.clone_from_cstring(str))
    return new_conn(sock, addr)
}