package example

main :: proc () {
    l, ok := tcp_listen(":80")
    if !ok{
        panic("couldn't start listening")
    }
    resp := "HTTP/1.1 200 OK\nContent-Length: 19\n\n{ \"is_valid\":true }"
    for{
        conn, ok := accept(l)
        if !ok{
            return
        }
        _, ok = read(conn, nil)
        if !ok{
            return
        }
        write_string(conn, resp)
    }
}