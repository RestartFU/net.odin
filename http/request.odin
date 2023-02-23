package http

import "core:fmt"
import "core:strings"
import net "../"
import url "../url"

Request :: struct {
    method : string,
    url : ^url.URL,
    proto : string,
    headers : header,
    user_agent: string,
    body : []byte,
}

new_request_url :: proc (method: string, uri: ^url.URL, body: []byte) -> (^Request, bool) {
    req := new(Request)
    if uri.scheme == "http" || uri.scheme == "https" {
        req.proto = "HTTP/1.1"
    }
    req.method = method
    req.user_agent = "Odin-http-client/1.1"
    req.url = uri
    req.body = body
    req.headers = make(header)
    return req, true
}

new_request :: proc (method, raw_url: string, body: []byte) -> (^Request, bool) {
    if !valid_method(method) {
        return nil, false
    }
    url, ok := url.parse(raw_url)
    if !ok {
        return nil, false
    }
    return new_request_url(method, url, body)
}

parse_request :: proc (req: ^Request) -> string {
    r := fmt.tprintf(
        "%s %s %s\nHost: %s\nUser-Agent: %s\n",
        req.method,
        req.url.path,
        req.proto,
        req.url.host,
        req.user_agent,
    )
    for k, v in req.headers {
        r = strings.concatenate([]string{r, k, ": ", req.headers[k], "\n"})
    }
    r = strings.concatenate([]string{r, "\n", string(req.body)})
    return r
}

parse_request_from_string :: proc (str: string) -> (^Request, bool) {
    split := strings.split(str, "\r\n")
    if len(split) < 1 {
        return nil, false
    }
    inf := strings.split(split[0], " ")
    if len(inf) < 3 {
        return nil, false
    }

    req := new(Request)
    req.method = inf[0]
    url := new(url.URL)
    url.path = inf[1]
    req.url = url
    req.proto = inf[2]

    headers := make(header)
    split = split[1:]
    i := 1
    for s, _ in split {
        hd := strings.split(s, ": ")
        if len(hd) < 2 {
            continue
        }
        headers[hd[0]] = strings.trim_right(strings.trim_left(hd[1], "\""), "\"")
        i += 1
    }
    req.headers = headers
    if l, ok := headers["User-Agent"]; ok {
            req.user_agent = l
    }
    body := strings.join(split[i:], "\n")
    if len(body) > 0 {
        req.body = transmute([]byte)body
    }

    return req, true
}

do_request :: proc (req: ^Request) -> (^Response, bool) {
    conn, ok := net.tcp_connect(req.url.host)
    if !ok {
        return nil, false
    }
    _, ok = net.write_string(conn, parse_request(req))
    if !ok {
        return nil, false
    }
    str, _ := net.read_string(conn)
    return parse_response_from_string(str)
}

valid_method :: proc (method: string) -> bool {
    return method == "GET" || method == "POST" || method == "PUT" || method == "DELETE"
}