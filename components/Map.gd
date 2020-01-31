extends Node

var move_range_rects = []
var characters = {}

func init(pos = Vector2(0, 0)):
    $TileMap.position = pos
    Game.connect("game_init_character", self, "create_character")
    Game.connect("game_show_character_move_range", self, "show_character_move_range")
    Game.connect("game_hide_character_move_range", self, "hide_character_move_range")
    Game.connect("game_move_character", self, "move_character")
    
func create_character(map_pos = Game.MapPos.new(), character_id = -1):
    var Character = load("res://components/Character.tscn").instance()
    add_child(Character)
    Character.init(map_pos, character_id)
    characters[character_id] = Character
    
func show_character_move_range(move_range):
    for pos in move_range:
        var rect = ColorRect.new()
        rect.color = Color(0.070588, 0.535172, 0.945098, 0.392157)
        rect.rect_position = Vector2(Game.TILE_SIZE * pos.x, Game.TILE_SIZE * pos.y)
        rect.rect_size = Vector2(Game.TILE_SIZE, Game.TILE_SIZE)
        add_child(rect)
        move_range_rects.push_back(rect)
        
func hide_character_move_range():
    for rect in move_range_rects:
        remove_child(rect)
    move_range_rects = []

func move_character(map_pos, character_id):
    if characters.has(character_id):
        characters[character_id].move_to(map_pos)
    
    