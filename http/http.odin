package http

import "core:strings"

has_port :: proc (s: string) -> bool {
    return strings.last_index(s, ":") > strings.last_index(s, "]")
}

remove_empty_port :: proc (host: string) -> string {
    if has_port(host) {
		return strings.trim_suffix(host, ":")
	}
    return host
}