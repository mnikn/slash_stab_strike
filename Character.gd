extends Node

var playerSelected = false

func init(pos = Vector2(0, 0)):
    get_node("Sprite").position = pos
    
func onPlayerClick():
    playerSelected = !playerSelected