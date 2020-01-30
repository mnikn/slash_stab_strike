extends Node

func _ready():
    get_node("/root/Game").connect("game_init_map", self, "init")

func init(pos = Vector2(0, 0)):
    $TileMap.position = pos
    get_node("/root/Game").connect("game_toggle_character_move_range", self, "toggle_character_move_range")

func toggle_character_move_range():
    pass