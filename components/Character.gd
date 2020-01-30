extends Node

var playerSelected = false

func init(pos = Vector2(0, 0)):
    $Sprite.position = pos
    
func onPlayerClick():
    playerSelected = !playerSelected