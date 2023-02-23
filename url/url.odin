package url

import "core:strings"
import "core:fmt"

// URL is a struct that represents a URL.
URL :: struct {
    scheme: string,
	host: string,
	path: string,
}

// parse parses a raw URL and returns a URL struct.
parse :: proc (raw_url: string) -> (^URL, bool) {
    if raw_url == "" {
        return nil, false
    }
    url := new(URL)
    scheme, rest, ok := get_scheme(raw_url)
    if !ok {
        return nil, false
    }
	url.scheme = scheme
	if strings.has_prefix(rest, "//") {
		rest = rest[2:]
	}
	host, path := rest, "/"
	if i := strings.index(rest, "/"); i >= 0 {
		host = rest[:i]
		path = rest[i:]
	}
	if !strings.contains(host, ":") {
		host = strings.concatenate([]string{host, ":80"})
	}
	url.host = host
	url.path = path
    return url, true
}

// get_scheme returns the scheme and the rest of the URL.
get_scheme :: proc (raw_url: string) -> (string, string, bool){
    for i in 0..=len(raw_url) {
		c := raw_url[i]
		switch {
		case 'a' <= c && c <= 'z' || 'A' <= c && c <= 'Z':
		// do nothing
		case '0' <= c && c <= '9' || c == '+' || c == '-' || c == '.':
			if i == 0 {
				return "", raw_url, true
			}
		case c == ':':
			if i == 0 {
				return "", "", false
			}
			return raw_url[:i], raw_url[i+1:], true
		}
	}
	return "", raw_url, true
}