package first_game

import "core:fmt"
import "core:log"
import "core:os"
import MIX "vendor:sdl2/mixer"

CHUNK :: MIX.Chunk
MUSIC :: MIX.Music

// where should this go? Change the hardcoded value. 
sounds : [8]^CHUNK

load_music :: proc(file_name: cstring) -> (^MIX.Music) {
	mus := MIX.LoadMUS(file_name)
	return mus
}

play_music :: proc(mus: ^MUSIC, loop : i32) {
	MIX.PlayMusic(mus, loop)
}

play_sound :: proc(id: i32, channel: i32) {
	MIX.PlayChannel(channel, sounds[id], 0)
}