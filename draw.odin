package first_game

import "core:fmt"
import "core:log"
import "core:os"
import SDL "vendor:sdl2"
import SDL_Image "vendor:sdl2/image"

/*
prepare_scene :: proc() {
	SDL.RenderDrawColor(ctx.renderer, 96, 128, 255, 255)
	SDL.RenderClear(ctx.renderer)
}
*/

present_scene :: proc() {
	SDL.RenderPresent(ctx.renderer)
}

load_texture :: proc(file_name: cstring) -> (^SDL.Surface) {
	surf := SDL_Image.Load(file_name)
	return surf
}

draw :: proc() {
	// Renderpresent per texture causes flickering
	SDL.RenderClear(ctx.renderer)
	number_entities := len(ctx.entities)
	for i := 0; i < number_entities; i += 1 {
		SDL.RenderCopy(ctx.renderer, ctx.entities[i].tex, &ctx.entities[i].source, &ctx.entities[i].dest)
		
	}
	present_scene()
}



