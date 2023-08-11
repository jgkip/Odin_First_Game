package main

import "core:fmt"
import "core:log"
import "core:os"
import SDL "vendor:sdl2"
import SDL_Image "vendor:sdl2/image"

WINDOW_TITLE  :: "Game"
WINDOW_X      := i32(400)
WINDOW_Y      := i32(400)
WINDOW_WIDTH  := i32(1280)
WINDOW_HEIGHT := i32(720)
WINDOW_FLAGS  :: SDL.WindowFlags{.SHOWN}
CENTER_WINDOW :: true

PLAYER_WIDTH : i32 = 24
PLAYER_HEIGHT : i32 = 36 

// Generic texture struct 
Entity :: struct {
	tex: ^SDL.Texture, // image 
	source: SDL.Rect, // sprite sheet 
	dest: SDL.Rect,   // place source sprite here 
}

Pos :: struct {
	x: i32, 
	y: i32, 
}

CTX :: struct {
	window: ^SDL.Window, 
	renderer: ^SDL.Renderer, 
	player: Entity,

	player_left_clips: [4]Pos, 
	player_right_clips: [4]Pos, 
	player_up_clips: [4]Pos, 
	player_down_clips: [4]Pos, 

	moving_left: bool, 
	moving_right: bool, 
	moving_up: bool, 
	moving_down: bool,

	should_close: bool,
}

ctx := CTX{
	player_left_clips = [4]Pos {
		Pos{x= 0, y = PLAYER_HEIGHT},
		Pos{x = PLAYER_WIDTH, y = PLAYER_HEIGHT},
		Pos{x = PLAYER_WIDTH * 2, y = PLAYER_HEIGHT},
		Pos{x = PLAYER_WIDTH, y = PLAYER_HEIGHT}, // cycle to beginning of clip 
	}, 
	player_right_clips = [4]Pos {
		Pos{x= 0, y = PLAYER_HEIGHT * 2},
		Pos{x = PLAYER_WIDTH, y = PLAYER_HEIGHT * 2 },
		Pos{x = PLAYER_WIDTH * 2, y = PLAYER_HEIGHT * 2},
		Pos{x = PLAYER_WIDTH, y = PLAYER_HEIGHT * 2},
	}, 
	player_up_clips = [4]Pos {
		Pos{x= 0, y = PLAYER_HEIGHT * 3},
		Pos{x = PLAYER_WIDTH, y = PLAYER_HEIGHT * 3},
		Pos{x = PLAYER_WIDTH * 2, y = PLAYER_HEIGHT * 3},
		Pos{x = PLAYER_WIDTH, y = PLAYER_HEIGHT * 3},
	}, 
	player_down_clips = [4]Pos {
		Pos{x= 0, y = 0},
		Pos{x = PLAYER_WIDTH, y = 0},
		Pos{x = PLAYER_WIDTH * 2, y = 0},
		Pos{x = PLAYER_WIDTH, y = 0},
	}, 
}

init_sdl :: proc() -> (ok: bool) {
	if sdl_res := SDL.Init(SDL.INIT_VIDEO); sdl_res < 0 {
		log.errorf("sdl2.init returned %v.", sdl_res)
		return false 
	}
	// set up flags 
	
	img_init_flags := SDL_Image.INIT_PNG
	img_res := SDL_Image.InitFlags(SDL_Image.Init(img_init_flags))
	if img_init_flags != img_res {
		log.errorf("sdl2_image.init returned %v.", img_res)
	}
	

	if CENTER_WINDOW {
		bounds := SDL.Rect{}
		if e: = SDL.GetDisplayBounds(0, &bounds); e != 0 {
			log.errorf("Unable to get desktop bounds.")
			return false 
		}
		WINDOW_X = ((bounds.w - bounds.x) / 2) - (WINDOW_WIDTH / 2) + bounds.x
		WINDOW_Y = ((bounds.h - bounds.y) / 2) - (WINDOW_HEIGHT / 2) + bounds.y
	}

	// Attempt to create the context's window and renderer
	ctx.window = SDL.CreateWindow(WINDOW_TITLE, WINDOW_X, WINDOW_Y, WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_FLAGS)

	if ctx.window == nil {
		log.errorf("sdl.CreateWindow failed.")
		return false 
	}

	ctx.renderer = SDL.CreateRenderer(ctx.window, -1, {.ACCELERATED, .PRESENTVSYNC})
	if ctx.renderer == nil {
		log.errorf("sdl2.CreateRenderer failed.")
		return false 
	}
	return true

}

cleanup :: proc() {
	SDL.DestroyWindow(ctx.window)
	SDL.Quit()
}

process_input :: proc() {
	e: SDL.Event
	for SDL.PollEvent(&e) {
		#partial switch(e.type) {
			case .QUIT: 
				ctx.should_close = true
			case .KEYDOWN:
				#partial switch(e.key.keysym.sym) {
					case .ESCAPE:
						ctx.should_close = true
				}
		}
	}
}

process_player_input :: proc() {
	state := SDL.GetKeyboardState(nil)
	ctx.moving_left  =	state[SDL.Scancode.A] > 0
	ctx.moving_down  =  state[SDL.Scancode.S] > 0
	ctx.moving_right =  state[SDL.Scancode.D] > 0
	ctx.moving_up    = 	state[SDL.Scancode.W] > 0
}

update :: proc() {
	speed: i32 = 3
	animation_speed := SDL.GetTicks() / 200 // GetTicks gets the ms since SDL was initialized
	idx := animation_speed %% 4 // 0 - 3


	// Change the source sprite 
	// then, move the destination rectangle 
	if ctx.moving_left {
		src := ctx.player_left_clips[idx]
		ctx.player.source.x = src.x 
		ctx.player.source.y = src.y 
		ctx.player.dest.x -= speed
	}
	if ctx.moving_down {
		src := ctx.player_down_clips[idx]
		ctx.player.source.x = src.x
		ctx.player.source.y = src.y
		ctx.player.dest.y += speed
	}
	if ctx.moving_right {
		src := ctx.player_right_clips[idx]
		ctx.player.source.x = src.x
		ctx.player.source.y = src.y
		ctx.player.dest.x += speed
	}
	if ctx.moving_up {
		src := ctx.player_up_clips[idx]
		ctx.player.source.x = src.x
		ctx.player.source.y = src.y 
		ctx.player.dest.y -= speed
	}
}

draw :: proc() {
	SDL.RenderCopy(ctx.renderer, ctx.player.tex, &ctx.player.source, &ctx.player.dest)
	SDL.RenderPresent(ctx.renderer)
	SDL.RenderClear(ctx.renderer)
}

loop :: proc() {
	for !ctx.should_close {
		process_input()
		process_player_input()
		update()
		draw()
	}
	
}
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





















