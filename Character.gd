extends Node

var playerSelected = false

func _ready():
    get_node("/root/Game").connect("game_init_character", self, "init")

func init(pos = Vector2(0, 0)):
    get_node("Sprite").position = pos
    
func onPlayerClick():
    playerSelected = !playerSelected