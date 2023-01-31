package net

import "core:strings"

TcpConn :: struct {
    sock: SOCKET,
    remote_addr : Addr,
}

@(private)
// TCP is the type of the TCP protocol to use in windows.socket.
TCP : i32 = 0

// new_conn creates and returns a new Conn struct.
new_tcp_conn :: proc (sock : SOCKET, remote_addr: Addr) -> (^TcpConn, bool) {
    if sock == INVALID_SOCKET {
        return nil, false
    }
    
    c := new(TcpConn)
    c.sock = sock
    c.remote_addr = remote_addr
    
    return c, true
}

// tcp_connect_addr creates a TCP connection to the specified address.
tcp_connect_addr :: proc (addr: Addr) -> (^TcpConn, bool) {
    sock := socket(AF_INET, SOCK_STREAM, TCP);

    server_addr: sockaddr_in;
    server_addr.sin_family = u16(AF_INET);
    server_addr.sin_port = htons(u16(addr.port));
    server_addr.sin_addr.s_addr = u32(inet_addr(strings.clone_to_cstring(addr.ip)));

    res := connect(sock, cast(^SOCKADDR)&server_addr, size_of(server_addr));
    if res < 0 {
        return nil, false;
    }

    return new_tcp_conn(sock, addr)
}

// tcp_connect creates a TCP connection to the specified address.
tcp_connect :: proc (address: string) -> (^TcpConn, bool) {
    addr, ok := addr_from_string(address)
    if !ok {
        return nil, ok
    }
    return tcp_connect_addr(addr)
}