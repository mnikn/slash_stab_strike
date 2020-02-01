extends Node
        
const TILE_SIZE = 16
const TILE_NUM_X = 30
const TILE_NUM_Y = 30
var map
var cursor
var round_manager
var cache_select_character_move_range
var cache_select_character_attack_range

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
    round_manager.start()

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
        
    if event.is_action_pressed("ui_cancel"):
        round_manager.get_current_round().cancel_action()
    elif event.is_action_pressed("select"):
        handle_cursor_select()

func handle_cursor_select():
    var current_round = round_manager.get_current_round()
    var pointing_character = current_round.get_character_by_pos(cursor.pos)
    var selecting_character = current_round.get_selecting_character()
    if pointing_character != null && pointing_character.team == Round.CHARACTER_TEAM.PLAYER && pointing_character.round_state is RoundState.RoundStateIdle:
        current_round.show_character_move_range(pointing_character.id)
    elif selecting_character != null:
        if selecting_character.round_state is RoundState.RoundStateMoveSelecting:
            current_round.move_character(selecting_character.id, cursor.pos.clone())
        elif selecting_character.round_state is RoundState.RoundStateAttackSelecting:
            current_round.show_attack_part(selecting_character.id, cursor.pos.clone())

func on_attack_option_press(attack_part):
    var current_round = round_manager.get_current_round()
    current_round.attack(attack_part)

func on_action_option_press(action_type):
    var current_round = round_manager.get_current_round()    
    if action_type == Character.CHARACTER_ACTION.ATTACK:
        current_round.show_character_attack_range()
    elif action_type == Character.CHARACTER_ACTION.WAIT:
        current_round.character_wait()
    elif action_type == Character.CHARACTER_ACTION.CANCEL:
        current_round.cancel_action()