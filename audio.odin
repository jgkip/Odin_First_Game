package first_game

import "core:fmt"
import "core:log"
import "core:os"
import MIX "vendor:sdl2/mixer"

load_music :: proc(file_name: cstring) -> (^MIX.Music) {
	mus := MIX.LoadMUS(file_name)
	return mus
}

play_music :: proc(mus: ^MIX.Music, loop : i32) {
	MIX.PlayMusic(mus, loop)
}