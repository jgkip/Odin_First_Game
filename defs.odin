package first_game

WINDOW_TITLE  :: "Game"
WINDOW_X      := i32(400)
WINDOW_Y      := i32(400)
WINDOW_WIDTH  := i32(1280)
WINDOW_HEIGHT := i32(720)
CENTER_WINDOW :: true

PLAYER_WIDTH  : i32 = 24
PLAYER_HEIGHT : i32 = 36 
PLAYER_SPEED  : i32 = 3

MAX_SND_CHANNELS := i32(8)

Channels :: enum {
	CH_ANY,
	CH_PLAYER
}

Sounds :: enum {
	SND_PLAYER_MOVE
}


