package http

import "core:strings"

// has_port returns true if the host string contains a port number.
has_port :: proc (s: string) -> bool {
    return strings.last_index(s, ":") > strings.last_index(s, "]")
}

// remove_empty_port removes the port number from the host string if it is empty.
remove_empty_port :: proc (host: string) -> string {
    if has_port(host) {
		return strings.trim_suffix(host, ":")
	}
    return host
}