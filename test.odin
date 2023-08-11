package main

import "core:fmt"
import SDL "vendor:sdl2"
import SDL_Image "vendor:sdl2/image"

WINDOW_TITLE :: "Title"
WINDOW_X : i32 = SDL.WINDOWPOS_UNDEFINED
WINDOW_Y : i32 = SDL.WINDOWPOS_UNDEFINED
WINDOW_W : i32 = 1200
WINDOW_H : i32 = 1000
PLAYER_WIDTH : i32 = 24
PLAYER_HEIGHT : i32 = 36 

WINDOW_FLAGS :: SDL.WINDOW_SHOWN

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

main :: proc() {
	speed : i32 = 10
	// Initializing SDL stuff 
	SDL.Init(SDL.INIT_VIDEO)
	SDL_Image.Init(SDL_Image.INIT_PNG)

	// Create window and renderer
	ctx.window = SDL.CreateWindow(WINDOW_TITLE, WINDOW_X, WINDOW_Y, WINDOW_W, WINDOW_H, WINDOW_FLAGS)
	ctx.renderer = SDL.CreateRenderer(
		ctx.window, 
		-1, 
		SDL.RENDERER_PRESENTVSYNC | SDL.RENDERER_ACCELERATED | SDL.RENDERER_TARGETTEXTURE)
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
	game_loop: for {
		state = SDL.GetKeyboardState(nil)
		ctx.moving_left  =	state[SDL.Scancode.A] > 0
		ctx.moving_down  =  state[SDL.Scancode.S] > 0
		ctx.moving_right =  state[SDL.Scancode.D] > 0
		ctx.moving_up    = 	state[SDL.Scancode.W] > 0

		if SDL.PollEvent(&event) {
			if event.type == SDL.EventType.QUIT {
				break game_loop 
			}
			if event.type == SDL.EventType.KEYDOWN {
				#partial switch event.key.keysym.scancode
				{
					case .L:
						fmt.println("Log:")
					case .SPACE:
						fmt.println("Space")
				}
			}
			if event.type == SDL.EventType.KEYUP {
			}
		}
		
		animation_speed := SDL.GetTicks() / 175 // GetTicks gets the ms since SDL was initialized
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

		SDL.RenderCopy(ctx.renderer, ctx.player.tex, &ctx.player.source, &ctx.player.dest)

		SDL.RenderPresent(ctx.renderer)
		SDL.RenderClear(ctx.renderer)
	}		

	SDL.DestroyWindow(ctx.window)
	SDL.Quit()
} 





















