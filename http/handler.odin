package http

import net "../"
import template "../http/template"
import http "../http"

// Handler is a struct that holds the endpoints and the page not found template.
Handler :: struct {
    endpoints: map[string]handler_proc,
    page_not_found: template.Template,
}

// handler_proc is a function that takes a connection and a request and returns a response.
handler_proc :: proc(^net.Conn, ^Request) -> ^http.Response

// handle is a function that takes a handler, a path and a handler_proc and adds the handler_proc to the endpoints map.
handle :: proc(h: ^Handler, path: string, prc: handler_proc) {
    h.endpoints[path] = prc
}