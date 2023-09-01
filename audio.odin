package first_game

import "core:fmt"
import "core:log"
import "core:os"
import MIX "vendor:sdl2/mixer"

load_music :: proc(file_name: cstring) -> (^MIX.Music) {
	mus := MIX.LoadMUS(file_name)
	return mus
}
