package net

import "core:strings"
import "core:strconv"

// IPv4 is the representation of an IPv4 address.
IPv4 :: string

// ipv4_by_name returns the IPv4 address of the given hostname.
ipv4_by_name :: proc (addr: string) -> IPv4 {
    if addr == "localhost" || len(addr) == 0 {
        return "127.0.0.1"
    }
    res: ^ADDRINFOA;

    getaddrinfo(strings.clone_to_cstring(addr), nil, nil, &res)
    return string(inet_ntoa((cast(^sockaddr_in)res.ai_addr).sin_addr))
}

// Addr is a struct that represents an ipv4 address and a port.
Addr :: struct {
    ip: IPv4,
    port: int,
}

// addr_from_string returns the Addr from the given string.
addr_from_string :: proc (host: string) -> (Addr, bool) {
    split := strings.split(host, ":")
    
    if len(split) != 2 {
        return Addr{}, false
    }

    ip := ipv4_by_name(split[0])
    port, ok := strconv.parse_int(split[1], 10)
    if !ok {
        return Addr{}, false
    }

    return Addr{ip, port}, true
}