extends Node

var game
func _ready():
    game = get_node("/root/Game")
    game.connect("game_init_map", self, "create_map")  
    game.connect("game_init_cursor", self, "create_cursor")
    game.connect("game_init_character", self, "create_character")
    game.init()

func create_map(tilePos = Vector2(0, 0)):
    var Map = load("res://components/Map.tscn").instance()
    add_child(Map)
    Map.init(getTilePos(tilePos))

func create_cursor(tilePos = Vector2(0, 0)):
    var Cursor = load("res://components/Cursor.tscn").instance()
    add_child(Cursor)
    Cursor.init(getTilePos(tilePos))
    
func create_character(tilePos = Vector2(0, 0)):
    var Character = load("res://components/Character.tscn").instance()
    add_child(Character)
    Character.init(getTilePos(tilePos))

func getTilePos(tilePos):
    return Vector2(tilePos.x * game.TILE_SIZE, tilePos.y * game.TILE_SIZE)