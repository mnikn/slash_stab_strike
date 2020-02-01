extends Node

var move_range_rects = []
var attack_range_rects = []
var characters = {}

func init(pos = Vector2(0, 0)):
    $TileMap.position = pos
    
    Events.connect("MAP_RERENDER", self, "render_round")
    Events.connect("MAP_SHOW_CHARACTER_MOVE_RANGE", self, "show_character_move_range")
    Events.connect("MAP_HIDE_CHARACTER_MOVE_RANGE", self, "hide_character_move_range")
    Events.connect("MAP_SHOW_CHARACTER_ATTACK_RANGE", self, "show_character_attack_range")
    Events.connect("MAP_HIDE_CHARACTER_ATTACK_RANGE", self, "hide_character_attack_range")
    Events.connect("MAP_MOVE_CHARACTER", self, "move_character")
    Game.connect("game_init_cursor", self, "create_cursor")
    
func create_cursor(map_pos):
    var Cursor = load("res://components/Cursor.tscn").instance()
    add_child(Cursor)
    Cursor.init(map_pos)
    
func render_round(latest_round):
    print(latest_round)
    for character in latest_round.characters.values():
        var node = load("res://components/Character.tscn").instance()
        add_child(node)
        node.init(character)
        characters[character.id] = node
    
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

func show_character_attack_range(attack_range):
    for pos in attack_range:
        var rect = ColorRect.new()
        rect.color = Color(0.945098, 0.070588, 0.070588, 0.392157)
        rect.rect_position = Vector2(Game.TILE_SIZE * pos.x, Game.TILE_SIZE * pos.y)
        rect.rect_size = Vector2(Game.TILE_SIZE, Game.TILE_SIZE)
        add_child(rect)
        attack_range_rects.push_back(rect)
func hide_character_attack_range():
    for rect in attack_range_rects:
        remove_child(rect)
    attack_range_rects = []

func move_character(character_id, map_pos):
    if characters.has(character_id):
        characters[character_id].move_to(map_pos)
    
    