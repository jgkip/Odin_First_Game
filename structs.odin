package first_game

import "core:fmt"
import "core:log"
import "core:os"
import SDL "vendor:sdl2"

// Generic texture struct 
Entity :: struct {
	name: 	cstring,
	tex: 	^SDL.Texture, // image 
	source: SDL.Rect, // sprite sheet 
	dest: 	SDL.Rect,   // place source sprite here 
}

Text :: struct {
	tex: 		^SDL.Texture, 
	text_rect: 	SDL.Rect,
}

Pos :: struct {
	x: i32, 
	y: i32, 
}

CTX :: struct {
	window: 	^SDL.Window, 
	renderer: 	^SDL.Renderer, 
	//player: Entity,
	//item: Entity,
	entities: 	[dynamic]Entity,
	game_text: 	Text,

	player_left_clips: 		[4]Pos, 
	player_right_clips: 	[4]Pos, 
	player_up_clips: 		[4]Pos, 
	player_down_clips: 		[4]Pos, 

	idle_frames: 		[10]Pos,
	knight_idle_frames: [10]Pos,
	knight_run_frames:  [10]Pos,

	moving_left: 	bool, 
	moving_right: 	bool, 
	moving_up: 		bool, 
	moving_down: 	bool,

	should_close: 	bool,
}