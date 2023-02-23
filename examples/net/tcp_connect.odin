package example

// you may change the import path to wherever you put the library.
import net "../../"
import "core:fmt"

tcp_connect :: proc (){
        // connecting to the remote host.
        conn, ok := net.tcp_connect(":80")
        if !ok {
            fmt.println("failed to connect")
            return
        }
        // make sure to close the socket once you're done with it.
        defer net.close(conn)
        
        // writing to the remote host.
        _, ok = net.write_string(conn, "hey")
        if !ok {
            fmt.println("failed to write")
            return
        }
        
        // reading incoming data from the remote host.
        str, ok2 := net.read_string(conn)
        if !ok2 {
            fmt.println("failed to read")
            return
        }
        
        // printing the received data.
        fmt.println(str)
}