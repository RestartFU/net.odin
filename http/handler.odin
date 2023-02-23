package http

import net "../"

Handler :: struct {
    h: map[string]handler_proc,
    page_not_found: any,
}

handler_proc :: proc(^net.Conn, ^Request)

handle :: proc(h: ^Handler, path: string, prc: handler_proc) {
    h.h[path] = prc
}