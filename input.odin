package first_game

import "core:fmt"
import "core:log"
import "core:os"
import SDL "vendor:sdl2"

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
