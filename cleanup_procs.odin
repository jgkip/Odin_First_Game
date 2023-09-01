package first_game

import "core:fmt"
import "core:log"
import "core:os"
import SDL "vendor:sdl2"
import MIX "vendor:sdl2/mixer"
import SDL_Image "vendor:sdl2/image"

cleanup :: proc() {
	SDL.DestroyWindow(ctx.window)
	SDL.Quit()
	log.infof("SDL closed.")
}

cleanup_audio :: proc(buffer: [^]u8, device: SDL.AudioDeviceID) {
	SDL.FreeWAV(buffer)
	SDL.CloseAudioDevice(device)
	log.infof("Audio closed.")
}

cleanup_music :: proc(music: ^MIX.Music) {
	MIX.FreeMusic(music)
	MIX.CloseAudio()
	MIX.Quit()
	log.infof("Music closed.")
}