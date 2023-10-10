package first_game
import SDL "vendor:sdl2"
import SDL_Image "vendor:sdl2/image"
/*
Texture loading and unloading 

How to determine which textures to preload/load and unload? 


Small game (without levels) --> load everything at the start
*/

load_texture :: proc(file_name: cstring) -> (^SDL.Surface) {
	surf := SDL_Image.Load(file_name)
	return surf
}

