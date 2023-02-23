package http

import net "../"
import "core:fmt"
import "template"

not_found_template := &template.Template{
    content = `<!DOCTYPE html>
    <html>
        <head>
            <title>Page not found</title>
        </head>
        <body>
            <p>404 Not Found</p>
        </body>
    </html>`,
}

not_found_404 := new(Response)

@(init)
init :: proc () {
    not_found_404.status = "404 Not Found"
    not_found_404.proto = "HTTP/1.1"
    not_found_404.body = template.parse_to_bytes(not_found_template, nil)
}

// listen_and_serve starts a server on the given address and serves using the given handler
listen_and_serve :: proc(addr: string, h: ^Handler) {
    l, ok := net.tcp_listen(addr)
    if !ok{
        panic("couldn't start listening")
    }

    for{
        conn, ok := net.accept(l)
        if !ok{
            panic("couldn't accept connection")
        }
        res, ok2 := net.read_string(conn)
        if !ok2{
            panic("couldn't read from connection")
        }
        req, ok3 := parse_request_from_string(res) 
        if !ok3 {
            panic("couldn't parse request")
        }
        path := req.url.path
        if prc, ok := h.endpoints[path]; ok{
            net.write(conn, prc(conn, req).body)
        }else {
            net.write_string(conn, parse_response_to_string(not_found_404))
        }
        net.close(conn)
    }
}