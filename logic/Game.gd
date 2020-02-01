extends Node
signal game_show_character_move_range(move_range)
signal game_move_character(move_pos, character_id)
signal game_hide_character_move_range()
signal game_init_map(mapPos)
signal game_init_cursor(map_pos)
signal game_create_character(map_pos, character_id)
signal game_move_cursor(mapPos)
signal game_create_action_panel()
signal game_destory_action_panel()
signal game_create_attack_panel()
signal game_destory_attack_panel()
signal game_action_attack()
signal game_action_wait()
        
const TILE_SIZE = 16
const TILE_NUM_X = 30
const TILE_NUM_Y = 30
var map
var cursor
var cache_select_character_move_range
var during_action = false

func init():
    cache_select_character_move_range = Utils.Set.new()
    map = Map.Map.new(TILE_NUM_X, TILE_NUM_Y)
    cursor = Cursor.Cursor.new(map)
    
    var mock_character_pos = Map.MapPos.new(10, 10)
    map.get(mock_character_pos).item = Character.Character.new(map, mock_character_pos)
    map.get(mock_character_pos).item.id = 1
    
    
    var mock_enemy_pos = Map.MapPos.new(20, 15)
    map.get(mock_enemy_pos).item = Character.Character.new(map, mock_enemy_pos)
    map.get(mock_enemy_pos).item.id = 2
    map.get(mock_enemy_pos).item.type = Character.CHARACTER_TYPE.ENEMY
    
    # emit signal update view
    emit_signal("game_init_map")
    emit_signal("game_init_cursor", Map.MapPos.new())
    emit_signal("game_create_character", mock_character_pos, 1)
    emit_signal("game_create_character", mock_enemy_pos, 2)
    
    connect("game_action_attack", self, "on_action_attack")
    connect("game_action_wait", self, "on_action_wait")

func _input(event):
    if !(event is InputEventKey):
        return
    
    var xDirection = event.get_action_strength("move_right") - event.get_action_strength("move_left")
    var yDirection = event.get_action_strength("move_down") - event.get_action_strength("move_up")
    # fixme: modifier not work
    var moveTileNum = 5 if event.is_action_pressed("shift_modifer") else 1
    var cursor_pos = cursor.pos.clone()
    if xDirection != 0:
        cursor_pos.x = clamp(cursor_pos.x - moveTileNum if xDirection < 0 else cursor_pos.x + moveTileNum, 0, TILE_NUM_X - 1)
    if yDirection != 0:
        cursor_pos.y = clamp(cursor_pos.y - moveTileNum if yDirection < 0 else cursor_pos.y + moveTileNum, 0, TILE_NUM_Y - 1)
        
    if xDirection != 0 || yDirection != 0:
        cursor.move_to(cursor_pos)
        emit_signal("game_move_cursor", cursor_pos)
    
    if event.is_action_pressed("select"):
        handle_cursor_select()

func handle_cursor_select():
    if during_action:
        return

    var current_pos_item = map.get(cursor.pos).item
    if cursor.selected_item is Character.Character:
        var cursor_pos = cursor.pos
        if cache_select_character_move_range.has(cursor_pos):
            cursor.selected_item.move_to(cursor_pos)            
            emit_signal("game_move_character", cursor_pos, cursor.selected_item.id)
            emit_signal("game_create_action_panel")
            during_action = true
        cache_select_character_move_range.clear()
        cursor.diselect()
        emit_signal("game_hide_character_move_range")
    elif current_pos_item is Character.Character && current_pos_item.type == Character.CHARACTER_TYPE.PLAYER:
        var move_range = current_pos_item.get_move_range()
        cache_select_character_move_range = move_range
        cursor.select(current_pos_item)
        emit_signal("game_show_character_move_range", move_range.to_array())
    else:
        cursor.diselect()

func on_action_attack():
    during_action = false
func on_action_wait():
    during_action = false