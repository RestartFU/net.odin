package net

import "network"
import "core:strings"

// Listener is a struct that represents a listener to a local address
Listener :: struct {
    sock: network.SOCKET,
    local_addr: Addr,
}

// new_listener creates and returns a new Listener struct
new_listener :: proc (sock : network.SOCKET, local_addr: Addr) -> (^Listener, bool) {
    if sock == network.INVALID_SOCKET {
        return nil, false
    }
    l := new(Listener)
    l.sock = sock
    l.local_addr = local_addr
	
    return l, network.listen(sock, 65535) >= 0
}

// accept wait for an incoming connection, and accepts it.
accept :: proc (listener: ^Listener) -> (^Conn, bool) {
    cli: network.sockaddr_in
    length := i32(size_of(cli))

    sock := network.accept(listener.sock, cast(^network.SOCKADDR)&cli, &length)
    if sock == network.INVALID_SOCKET {
        return nil, false
    }
    str: cstring
    network.inet_ntop(network.AF_INET, cli.sin_addr, str, 32)
    addr, _ := addr_from_string(strings.clone_from_cstring(str))
    return new_conn(sock, addr)
}