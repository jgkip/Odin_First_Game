package first_game

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
	box_img : ^SDL.Surface = SDL_Image.Load("assets/box.png")
	apple_img : ^SDL.Surface = SDL_Image.Load("assets/Apple.png")
	
	// TODO: Better texture loading
	// Create the player entity 
	append(&ctx.entities, Entity{
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
	})

	// box item 
	append(&ctx.entities, Entity{
		tex = SDL.CreateTextureFromSurface(ctx.renderer, box_img),
		source = SDL.Rect{
			x = 0,
			y = 0,
			w = 28,
			h = 24,
		},
		dest = SDL.Rect{
			x = 400,
			y = 400,
			w = 28 * 3,
			h = 24 * 3,
		}, 
	})

	// apple
	append(&ctx.entities, Entity{
		tex = SDL.CreateTextureFromSurface(ctx.renderer, apple_img),
		source = SDL.Rect{
			x = 0,
			y = 0,
			w = 32,
			h = 32,
		},
		dest = SDL.Rect{
			x = 200,
			y = 200,
			w = 32 * 3,
			h = 32 * 3,
		}, 
	})
	// 1. Update a copy of scene 
	// 2. Show copy 
	// 3. Clear screen 
	event : SDL.Event
	state : [^]u8
	loop()
} 





















