package example

import http "../../http"
import "core:fmt"

main :: proc () {
    r, ok := http.new_request("GET", "http://www.randomnumberapi.com/api/v1.0/random?min=100&max=1000&count=1", nil)
    if !ok{
        fmt.println("error")
    }
    resp, ok2 := http.do_request(r)
    if !ok2{
        fmt.println("error2")
    }
    fmt.println(transmute(string)resp.body)
}