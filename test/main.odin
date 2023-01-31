package main

import net "../"
import "core:fmt"

main :: proc (){
    tcp_conn, ok := net.tcp_connect("nitrofaction.fr:80")
    fmt.println(tcp_conn, ok)
}