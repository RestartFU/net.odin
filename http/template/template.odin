package template

import net "../../"
import "core:os"

Template :: struct {
    content: string,
}

new_from_file :: proc(path: string) -> (^Template, bool) {
    t := new(Template)
    d, ok := os.read_entire_file_from_filename(path)
    if !ok {
        return nil, false
    }
    t.content = string(d)
    return t, true
}

new_from_file_must :: proc(path: string) -> ^Template {
    t, _ := new_from_file(path)
    return t
}

parse_to_bytes :: proc (t: ^Template, args: any) -> []byte {
    return transmute([]byte)t.content
}