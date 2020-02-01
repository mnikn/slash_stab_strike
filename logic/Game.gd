extends Node
signal game_show_character_move_range(move_range)
signal game_hide_character_move_range()
signal game_show_character_attack_range(attack)
signal game_hide_character_attack_range()
signal game_move_character(character_id, move_pos)
signal game_init_cursor(map_pos)
signal game_move_cursor(mapPos)
signal game_show_action_panel()
signal game_hide_action_panel()
signal game_show_attack_panel()
signal game_hide_attack_panel()
signal game_action_attack()
signal game_action_wait()
        
const TILE_SIZE = 16
const TILE_NUM_X = 30
const TILE_NUM_Y = 30
var map
var cursor
var round_manager
var cache_select_character_move_range
var cache_select_character_attack_range
#var during_action_select = false

func init():
    cache_select_character_move_range = Utils.Set.new()
    cache_select_character_attack_range = Utils.Set.new()
    map = Map.Map.new(TILE_NUM_X, TILE_NUM_Y)
    cursor = Cursor.Cursor.new(map)
    
    var mock_player = Round.RoundCharacter.new(Character.Character.new(), Map.MapPos.new(5, 5), Round.CHARACTER_TEAM.PLAYER)
    var mock_enemy = Round.RoundCharacter.new(Character.Character.new(), Map.MapPos.new(7, 7), Round.CHARACTER_TEAM.ENEMY)
    var mock_characters = {}
    mock_characters[mock_player.id] = mock_player
    mock_characters[mock_enemy.id] = mock_enemy
    round_manager = RoundManager.RoundManager.new(map, mock_characters)
    
    # emit signal update view
    emit_signal("game_init_cursor", Map.MapPos.new())
    
    round_manager.start()
    RoundManager.emit_signal("ROUND_MANAGER_NEXT_ROUND", round_manager.get_current_round())

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
        
#    if event.is_action("ui_cancel"):
#        if (cursor.selected_item is Character.Character && 
#            cursor.selected_item.type == Character.CHARACTER_TYPE.PLAYER && 
#            cursor.selected_item.type == Character.CHARACTER_ACTION_STATE.ATTACK):
#
#            # cursor.selected_item.switch_to_state(Character.CHARACTER_ACTION_STATE.IDLE)
#            emit_signal("game_hide_character_attack_range")
#            emit_signal("game_create_action_panel")
#            during_action_select = true
    elif event.is_action_pressed("select"):
        handle_cursor_select()

func handle_cursor_select():
    var current_round = round_manager.get_current_round()
    var pointing_character = current_round.get_character_by_pos(cursor.pos)
    var selecting_character = current_round.get_selecting_character()
    if pointing_character != null && pointing_character.team == Round.CHARACTER_TEAM.PLAYER && pointing_character.round_state == Round.CHARACTER_ROUND_STATE.IDLE:
        current_round.show_character_move_range(pointing_character.id)
    elif selecting_character != null:
        if selecting_character.round_state == Round.CHARACTER_ROUND_STATE.MOVE_SELECTING:
            current_round.move_character(selecting_character.id, cursor.pos)
        elif selecting_character.round_state == Round.CHARACTER_ROUND_STATE.ATTACK_SELECTING:
            pass
            #current_round.character_select_attack_target(selecting_character.id)