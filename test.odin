package main
import "core:fmt"
import "core:log"
import "core:os"
import SDL "vendor:sdl2"
import SDL_Image "vendor:sdl2/image"
 
main :: proc() {
	// Initializing SDL stuff 
	context.logger = log.create_console_logger()

	if res := init_sdl(); !res {
		log.errorf("Initialization failed.")
		os.exit(1)
	}
	defer cleanup()
	
	// Load image 
	player_img : ^SDL.Surface = SDL_Image.Load("assets/bardo.png")

	// Create the player entity 
	ctx.player = Entity{
		tex = SDL.CreateTextureFromSurface(ctx.renderer, player_img), 
		source = SDL.Rect{
			// source sprite is down
			x = ctx.player_down_clips[1].x, 
			y = ctx.player_down_clips[1].y,
			w = 24, 
			h = 38,
		},
		dest = SDL.Rect{
			x = 100, 
			y = 100, 
			w = 24 * 2,
			h = 38 * 2,
		},
	}

	// 1. Update a copy of scene 
	// 2. Show copy 
	// 3. Clear screen 
	event : SDL.Event
	state : [^]u8
	loop()
} 





















