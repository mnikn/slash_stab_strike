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
        
class Map:
    var _map = []
    func _init(tile_size, tile_num_x, tile_num_y):
        for i in range(tile_num_x):
            for j in range(tile_num_y):
                var item = {
                    "id": null,
                    "type": "normal",
                    "pos": MapPos.new(i, j)
                }
                if i == 0 || i == tile_num_x - 1 || j == 0 || j == tile_num_y - 1:
                    item["type"] = "block"
                _map.push_back(item)
    func get(pos):
        for item in _map:
            if item.pos.equal(pos):
                return item
        return null
    func set(pos, val):
        for i in range(len(_map)):
            if _map[i].pos.equal(pos):
                _map[i] = val
        var item = { "pos": pos, "type": val["type"]}
        _map.push_back(item)
    func find(type):
        var result = []
        for item in _map:
            if item.type == type:
                result.push_back(item)
        return result
    func find_by_id(id):
        for item in _map:
            if item.id != null && item.id == id:
                return item
        return null
    func move(id, target_pos):
        var item = self.find_by_id(id)
        if item == null:
            return
        var origin_item = self.get(target_pos)        
        if origin_item != null:
            origin_item.pos = item.pos.clone()
        item.pos = target_pos.clone()
                    
const TILE_SIZE = 16
const TILE_NUM_X = 30
const TILE_NUM_Y = 30
var map = null
var cursor_pos = MapPos.new()
var select_character = null
var select_character_move_range = null

func init():
    select_character_move_range = Utils.Set.new()
    map = Map.new(TILE_SIZE, TILE_NUM_X, TILE_NUM_Y)
    var player = map.get(MapPos.new(10, 10))
    player["type"] = "player"
    player["id"] = "player"
    
    
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
    var player_pos = map.find_by_id("player").pos
    if select_character != null:
        if select_character_move_range.has(cursor_pos):
            emit_signal("game_move_character", cursor_pos)
            map.move("player", cursor_pos)
            # playerPos = cursor_pos.clone()
        select_character = null
        select_character_move_range.clear()
        emit_signal("game_hide_character_move_range")
    elif cursor_pos.equal(player_pos):
        var move_range = get_character_move_range(player_pos)
        move_range.remove(player_pos)
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