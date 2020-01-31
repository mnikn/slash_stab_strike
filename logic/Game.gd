extends Node
signal game_toggle_character_move_range
signal game_init_map(mapPos)
signal game_init_cursor(mapPos)
signal game_init_character(mapPos)
signal game_move_cursor(mapPos)

class MapPos:
    var x = 0
    var y = 0
    func _init(x = 0, y = 0):
        self.x = x
        self.y = y
    func update(x, y):
        self.x = x
        self.y = y
    func to_string():
        return "x: " + str(self.x) + " y: " + str(self.y) + "\n"
    func hash():
        return hash(self.to_string())

const TILE_SIZE = 16
const TILE_NUM_X = 30
const TILE_NUM_Y = 30
var map = []
var cursorMapPos = MapPos.new()
var playerPos = MapPos.new()

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
    
    playerPos.update(10, 10)
    
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
        cursorMapPos.x = clamp(cursorMapPos.x - moveTileNum if xDirection < 0 else cursorMapPos.x + moveTileNum, 0, TILE_NUM_X - 1)
    if yDirection != 0:
        cursorMapPos.y = clamp(cursorMapPos.y - moveTileNum if yDirection < 0 else cursorMapPos.y + moveTileNum, 0, TILE_NUM_Y - 1)
    if xDirection != 0 || yDirection != 0:
        emit_signal("game_move_cursor", cursorMapPos)
    
    if event.is_action_pressed("select"):
        handle_cursor_select()

func handle_cursor_select():
    var move_range = get_character_move_range(playerPos)
    move_range.remove(playerPos)
    print(move_range.to_array())
    emit_signal("game_toggle_character_move_range")  

func get_character_move_range(characterMapPos):
    # todo: get real move range
    return do_get_character_move_range(characterMapPos, 4, utils.Set.new())
    
func do_get_character_move_range(characterMapPos, limitStep, results):
    if (limitStep <= 0 || characterMapPos.x < 0 || characterMapPos.x >= TILE_NUM_X || characterMapPos.y < 0 || characterMapPos.y >= TILE_NUM_Y):
        return results
    if results.has(characterMapPos):
        return
    results.append(characterMapPos.to_string())
    var i = 1
    characterMapPos = MapPos.new(characterMapPos.x + i, characterMapPos.y)
    do_get_character_move_range(characterMapPos, limitStep - 1, results)
    characterMapPos = MapPos.new(characterMapPos.x - i, characterMapPos.y)
    do_get_character_move_range(characterMapPos, limitStep - 1, results)
    characterMapPos = MapPos.new(characterMapPos.x, characterMapPos.y + 1)
    do_get_character_move_range(characterMapPos, limitStep - 1, results)
    characterMapPos = MapPos.new(characterMapPos.x, characterMapPos.y - 1)
    do_get_character_move_range(characterMapPos, limitStep - 1, results)
    return results