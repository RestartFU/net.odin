package example

import net "../../"
import http "../../http"
import "core:fmt"

listen_and_serve :: proc () {
    h := new(http.Handler)
    http.handle(h, "/hello_world", test_h)
    http.listen_and_serve(":8080", h)
}

test_h ::proc(conn: ^net.Conn, req: ^http.Request) {
    r := new(http.Response)
    r.proto = "HTTP/1.1"
    r.status = "200 OK"
    v := `
    <!DOCTYPE html>
    <html>
        <head>
            <title>Hello, World!</title>
        </head>
        <body>
            <p>Hello, World!</p>
        </body>
    </html>
    `
    r.body = transmute([]byte)v
    net.write_string(conn, http.parse_response_to_string(r))
}