package first_game

import "core:fmt"
import "core:log"
import "core:os"
import SDL "vendor:sdl2"
import MIX "vendor:sdl2/mixer"
import SDL_Image "vendor:sdl2/image"
import TTF "vendor:sdl2/ttf"

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
	log.infof("SDL initialized.")
	defer cleanup()

	if aud := init_sdl_audio(); !aud {
		os.exit(1)
	}

	// Audio initialization 
	mus := load_music("assets/spring.mp3")
	if mus == nil {
		log.errorf("Couldn't load music.")
	}
	else {
		MIX.PlayMusic(mus, -1)
	}
	defer cleanup_music(mus)

	if TTF.Init() < 0 {
		log.errorf("Couldn't initialize ttf.")
	}
	else {
		log.infof("ttf initialized.")
	}
	defer TTF.Quit()

	font := TTF.OpenFont("assets/dogicapixel.ttf", 20)

	if font == nil {
		log.errorf("Couldn't open font.")
	}
	else {
		log.infof("Font opened.")
		// This is cursed. 
		text_color : SDL.Color = {100, 10, 200, 255}
		text_surface := TTF.RenderText_Solid(font, "Text", text_color)
		text_texture := SDL.CreateTextureFromSurface(ctx.renderer, text_surface)	
		SDL.FreeSurface(text_surface) // free pixel data since we saved it to a texture 
		tex_rec : SDL.Rect
		tex_rec.x = 0
		tex_rec.y = 10
		tex_rec.w = 100 
		tex_rec.h = 20
		ctx.game_text = Text{text_texture, tex_rec,}
	}
	
	/*
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
	defer cleanup_audio(wave_buffer, device)
	*/
	// Load image 
	ground_img := load_texture("assets/ground.png")
	player_img := load_texture("assets/bardo.png")
	player_idle := load_texture("assets/idle.png")
	box_img := load_texture("assets/box.png")
	apple_img := load_texture("assets/Apple.png")
	
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





















