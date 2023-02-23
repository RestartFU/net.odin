package http

import "core:strings"
import "core:strconv"
import "core:fmt"

// Response is a struct that represents a HTTP response.
Response :: struct {
    status: string,
    status_code : int,
    proto: string,
    content_length: int,
    headers : Header,
    body : []byte,
}

parse_response_to_string :: proc(resp: ^Response) -> string{
    str := make([dynamic]string)
    defer delete(str)

    append(&str, ..[]string{
        strings.concatenate({resp.proto, " ", resp.status}),
        fmt.tprintf("Content-Length: %d", len(resp.body)+1),
    })

    for h, v in resp.headers {
        append(&str, strings.concatenate({h, ": \"", v, "\""}))
    }

    if len(resp.body) > 0 {
        append(&str, ..[]string{
            "\n",
            string(resp.body),
        })
    }

    str_copy := make([]string, len(str))
    defer delete(str_copy)

    copy(str_copy[:], str[:])

    return strings.join(str_copy, "\n")
}

parse_response_from_string :: proc (resp: string) -> (^Response, bool) {
    split := strings.split(resp, "\r\n")
    if len(split) < 1 {
        return nil, false
    }
    inf := strings.split(split[0], " ")
    if len(inf) < 3 {
        return nil, false
    }
    status_code, ok := strconv.parse_int(inf[1], 10)
    if !ok{
        status_code = -1
    }

    resp := new(Response)
    resp.status_code = status_code
    resp.proto = inf[0]
    resp.status = strings.join(inf[1:], " ")
    resp.content_length = -1

    headers := make(Header)
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
    resp.headers = headers
    if l, ok := headers["Content-Length"]; ok {
        cl, ok := strconv.parse_int(l, 10)
        if ok {
            resp.content_length = cl
        }
    }
    body := strings.join(split[i:], "\n")
    if len(body) > 0 {
        resp.body = transmute([]byte)body
    }

    return resp, true
}