extends Node
signal game_toggle_character_move_range
signal game_init_map(pos)
signal game_init_cursor(pos)
signal game_init_character(pos)

const TILE_SIZE = 16
const TILE_NUM_X = 30
const TILE_NUM_Y = 30
var map = []

func init():
    for i in range(TILE_NUM_X):
        map.insert(i, [])
        for j in range(TILE_NUM_Y):
            map[i].insert(j, {
                "type": "normal"    
            })
            if i == 0 || i == TILE_NUM_X - 1 || j == 0 || j == TILE_NUM_Y - 1:
                map[i][j]["type"] = "block"
    map[0][0]["type"] = "cursor"
    map[10][10]["type"] = "player"
    
    print("asdw")
    # emit signal update view
    emit_signal("game_init_map")
    emit_signal("game_init_cursor")
    emit_signal("game_init_character", Vector2(10, 10))
    # ColorRect.new()
    pass

func handleCursorSelect():
    emit_signal("game_toggle_character_move_range")