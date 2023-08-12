package first_game

import "core:fmt"
import "core:log"
import "core:os"
import SDL "vendor:sdl2"
import SDL_Image "vendor:sdl2/image"

PLAYER_W : i32 = 48
PLAYER_H : i32 = 48

load_frames_pos :: proc() {
	num_frames := len(ctx.idle_frames)
	for i := 0; i < num_frames; i += 1 {
		ctx.idle_frames[i] = Pos{x = PLAYER_W * i32(i), y = 0}
	}
}

main :: proc() {
	load_frames_pos()
	// Initializing SDL stuff 
	context.logger = log.create_console_logger()

	if res := init_sdl(); !res {
		log.errorf("Initialization failed.")
		os.exit(1)
	}
	defer cleanup()

	wave_spec : SDL.AudioSpec
	wave_length : u32
	wave_buffer : [^]u8
	device : SDL.AudioDeviceID


	if SDL.LoadWAV("assets/spring.wav", &wave_spec, &wave_buffer, &wave_length) == nil {
		log.errorf("Couldn't open audio file.")
	}
	else {
		device = SDL.OpenAudioDevice(nil, false, &wave_spec, nil, false)
		if device == 0 {
			log.errorf("Sound device error.")
		}
		status := SDL.QueueAudio(device, wave_buffer, wave_length)
		SDL.PauseAudioDevice(device, false)
	}
	defer SDL.FreeWAV(wave_buffer)
	defer SDL.CloseAudioDevice(device)
	
	// Load image 
	ground_img : ^SDL.Surface = SDL_Image.Load("assets/ground.png")
	player_img : ^SDL.Surface = SDL_Image.Load("assets/bardo.png")
	player_idle : ^SDL.Surface = SDL_Image.Load("assets/idle.png")
	box_img : ^SDL.Surface = SDL_Image.Load("assets/box.png")
	apple_img : ^SDL.Surface = SDL_Image.Load("assets/Apple.png")
	
	// TODO: Better texture loading
	append(&ctx.entities, Entity{
		tex = SDL.CreateTextureFromSurface(ctx.renderer, ground_img), 
		source = SDL.Rect{
			// source sprite is down
			x = 0, 
			y = 0,
			w = 256, 
			h = 256,
		},
		dest = SDL.Rect{
			x = 0, 
			y = 0, 
			w = 256 * 5,
			h = 256 * 3,
		},
	})

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

	// idle guy 
	append(&ctx.entities, Entity{
		tex = SDL.CreateTextureFromSurface(ctx.renderer, player_idle),
		source = SDL.Rect{
			// source sprite is down
			x = 0, 
			y = 0,
			w = 48, 
			h = 48,
		},
		dest = SDL.Rect{
			x = 300, 
			y = 300, 
			w = 48 * 2,
			h = 48 * 2,
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





















