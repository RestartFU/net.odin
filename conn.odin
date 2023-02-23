package net

import "bindings"

// Conn is a struct that represents a connection to a remote host.
Conn :: struct {
    sock : bindings.SOCKET,
    remote_addr : Addr,
}

// new_conn creates and returns a new Conn struct.
new_conn :: proc (sock : bindings.SOCKET, remote_addr: Addr) -> (^Conn, bool) {
    if sock == bindings.INVALID_SOCKET {
        return nil, false
    }
    
    c := new(Conn)
    c.sock = sock
    c.remote_addr = remote_addr
    
    return c, true
}

// write writes data to the connection.
write :: proc (conn: ^Conn, data: []byte) -> (int, bool) {
    n := int(bindings.write(conn.sock, raw_data(data), i32(len(data)), 0))
    return n, n == len(data)
}

// write_string writes a string to the connection.
write_string :: proc (conn: ^Conn, str: string) -> (int, bool) {
    data := transmute([]byte)str
    n := int(bindings.write(conn.sock, raw_data(data), i32(len(data)), 0))
    return n, n == len(data)
}

// read reads data from the connection.
read :: proc (conn: ^Conn, buf: []byte) -> (int, bool) {
    n := int(bindings.read(conn.sock, raw_data(buf), i32(len(buf)), 0))
    return n, n >= 0
}

// read_string reads a data from the connection and returns it as a string.
read_string :: proc(conn: ^Conn) -> (string, bool) {
    buf := make([]byte, 65535)
    recv := bindings.read(conn.sock, raw_data(buf), i32(len(buf)), 0)
    if recv <= 0 {
        return "", false
    }
    return transmute(string)buf[:recv], true
}

// close closes the connection.
close :: proc (conn: ^Conn) -> int {
    n := bindings.close(conn.sock)
    free(conn)
    return int(n)
}