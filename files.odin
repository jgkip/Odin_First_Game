package first_game

import "core:fmt"
import "core:os"
import "core:path/filepath"
import "core:strings"

/*
File operations 
*/


// reference example: 
// https://github.com/odin-lang/examples/blob/master/by_example/dir_info/main.odin
print_file_info :: proc(fi: os.File_Info) {
    // Split the path into directory and filename
    _, filename := filepath.split(fi.fullpath)

    SIZE_WIDTH :: 12
    buf: [SIZE_WIDTH]u8

    // Print size to string backed by buf on stack, no need to free
    _size := "-" if fi.is_dir else fmt.bprintf(buf[:], "%v", fi.size)

    // Right-justify size for display, heap allocated
    size  := strings.right_justify(_size, SIZE_WIDTH, " ")
    defer delete(size)

    if fi.is_dir {
        fmt.printf("%v [%v]\n", size, filename)
    } else {
        fmt.printf("%v %v\n", size, filename)
    }
}


file_info_in_dir :: proc(file_name: string) {
	dir, err := os.open(file_name)
	defer os.close(dir)
	if err != os.ERROR_NONE {
        // Print error to stderr and exit with errorcode
        fmt.eprintln("Could not open directory for reading", err)
        os.exit(1)
    }
    files: []os.File_Info
    defer os.file_info_slice_delete(files)
	files, err = os.read_dir(dir, -1)
	if err != os.ERROR_NONE {
        fmt.eprintln("Could not read directory", err)
        os.exit(2)
    }
	for file in files {
		print_file_info(file)
	}
}

