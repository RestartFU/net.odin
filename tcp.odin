package net

import "bindings"
import "core:strings"

@(private)
// TCP is the type of the TCP protocol to use in windows.socket.
TCP : i32 = 0

// tcp_listen listens for incoming connections to the specified address.
tcp_listen_addr :: proc (addr: Addr) -> (^Listener, bool) {
    sock := bindings.socket(bindings.AF_INET, bindings.SOCK_STREAM, TCP);

    server_addr: bindings.sockaddr_in;
    server_addr.sin_family = u16(bindings.AF_INET);
    server_addr.sin_port = bindings.htons(u16(addr.port));
    server_addr.sin_addr.s_addr = u32(bindings.inet_addr(strings.clone_to_cstring(addr.ip)));

    res := bindings.bind(sock, cast(^bindings.SOCKADDR)&server_addr, size_of(server_addr));
    if res < 0 {
        return nil, false;
    }
    return new_listener(sock, addr)
}

// tcp_listen listens for incoming connections to the specified address.
tcp_listen :: proc (address: string) -> (^Listener, bool) {
    addr, ok := addr_from_string(address)
    if !ok {
        return nil, ok
    }
    return tcp_listen_addr(addr)
}

// tcp_connect_addr creates a TCP connection to the specified address.
tcp_connect_addr :: proc (addr: Addr) -> (^Conn, bool) {
    sock := bindings.socket(bindings.AF_INET, bindings.SOCK_STREAM, TCP);

    server_addr: bindings.sockaddr_in;
    server_addr.sin_family = u16(bindings.AF_INET);
    server_addr.sin_port = bindings.htons(u16(addr.port));
    server_addr.sin_addr.s_addr = u32(bindings.inet_addr(strings.clone_to_cstring(addr.ip)));

    res := bindings.connect(sock, cast(^bindings.SOCKADDR)&server_addr, size_of(server_addr));
    if res < 0 {
        return nil, false;
    }

    return new_conn(sock, addr)
}

// tcp_connect creates a TCP connection to the specified address.
tcp_connect :: proc (address: string) -> (^Conn, bool) {
    addr, ok := addr_from_string(address)
    if !ok {
        return nil, ok
    }

    return tcp_connect_addr(addr)
}