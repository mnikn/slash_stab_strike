extends Node
signal game_toggle_character_move_range
signal game_init_map(tilePos)
signal game_init_cursor(tilePos)
signal game_init_character(tilePos)
signal game_move_cursor(tilePos)

class TilePos:
    var x = 0
    var y = 0
    func _init(x = 0, y = 0):
        self.x = x
        self.y = y

const TILE_SIZE = 16
const TILE_NUM_X = 30
const TILE_NUM_Y = 30
var map = []
var cursorTilePos = TilePos.new()

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
    
    # emit signal update view
    emit_signal("game_init_map")
    emit_signal("game_init_cursor")
    emit_signal("game_init_character", Vector2(10, 10))
    # ColorRect.new()
    pass

func _input(event):
    if !(event is InputEventKey):
        return
    
    var xDirection = event.get_action_strength("move_right") - event.get_action_strength("move_left")
    var yDirection = event.get_action_strength("move_down") - event.get_action_strength("move_up")
    # fixme: modifier not work
    var moveTileNum = 5 if event.is_action_pressed("shift_modifer") else 1
    if xDirection != 0:
        cursorTilePos.x = clamp(cursorTilePos.x - moveTileNum if xDirection < 0 else cursorTilePos.x + moveTileNum, 0, TILE_NUM_X - 1)
    if yDirection != 0:
        cursorTilePos.y = clamp(cursorTilePos.y - moveTileNum if yDirection < 0 else cursorTilePos.y + moveTileNum, 0, TILE_NUM_Y - 1)
    emit_signal("game_move_cursor", cursorTilePos)

func handleCursorSelect():
    emit_signal("game_toggle_character_move_range")