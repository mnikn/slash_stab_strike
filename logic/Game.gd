extends Node
signal game_show_character_move_range(move_range)
signal game_move_character(move_pos)
signal game_hide_character_move_range()
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
    func equal(pos):
        return self.x == pos.x && self.y == pos.y
    func clone():
        return MapPos.new(self.x, self.y)

const TILE_SIZE = 16
const TILE_NUM_X = 30
const TILE_NUM_Y = 30
var map = []
var cursor_pos = MapPos.new()
var playerPos = MapPos.new()
var select_character = null
var select_character_move_range = null

func init():
    select_character_move_range = Utils.Set.new()
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
        cursor_pos.x = clamp(cursor_pos.x - moveTileNum if xDirection < 0 else cursor_pos.x + moveTileNum, 0, TILE_NUM_X - 1)
    if yDirection != 0:
        cursor_pos.y = clamp(cursor_pos.y - moveTileNum if yDirection < 0 else cursor_pos.y + moveTileNum, 0, TILE_NUM_Y - 1)
    if xDirection != 0 || yDirection != 0:
        emit_signal("game_move_cursor", cursor_pos)
    
    if event.is_action_pressed("select"):
        handle_cursor_select()

func handle_cursor_select():
    if select_character != null:
        if select_character_move_range.has(cursor_pos):
            emit_signal("game_move_character", cursor_pos)
            playerPos = cursor_pos.clone()
        select_character = null
        select_character_move_range.clear()
        emit_signal("game_hide_character_move_range")
    elif cursor_pos.equal(playerPos):
        var move_range = get_character_move_range(playerPos)
        move_range.remove(playerPos)
        select_character_move_range = move_range
        # todo: get real character info
        select_character = {}
        emit_signal("game_show_character_move_range", move_range.to_array())

func get_character_move_range(characterMapPos):
    # todo: get real move range
    return do_get_character_move_range(characterMapPos, 4, Utils.Set.new())
    
func do_get_character_move_range(character_pos, limitStep, results):
    if (limitStep < 0 || character_pos.x < 0 || character_pos.x >= TILE_NUM_X || character_pos.y < 0 || character_pos.y >= TILE_NUM_Y):
        return results
    results.append(character_pos)
    do_get_character_move_range(MapPos.new(character_pos.x + 1, character_pos.y), limitStep - 1, results)
    do_get_character_move_range(MapPos.new(character_pos.x - 1, character_pos.y), limitStep - 1, results)
    do_get_character_move_range(MapPos.new(character_pos.x, character_pos.y + 1), limitStep - 1, results)
    do_get_character_move_range(MapPos.new(character_pos.x, character_pos.y - 1), limitStep - 1, results)
    return results