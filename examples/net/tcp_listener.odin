package example

import net "../../"

tcp_listener :: proc () {
    l, ok := net.tcp_listen(":80")
    if !ok{
        panic("couldn't start listening")
    }
    resp := "HTTP/1.1 200 OK\nContent-Length: 19\n\n{ \"is_valid\":true }"
    for{
        conn, ok := net.accept(l)
        if !ok{
            return
        }
        _, ok = net.read(conn, nil)
        if !ok{
            return
        }
        net.write_string(conn, resp)
    }
}