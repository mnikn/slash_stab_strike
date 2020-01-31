extends Node

func init(map_pos):
    var pos = Utils.get_physic_pos(map_pos)
    $Sprite.position = pos
    
func move_to(map_pos):
    $Sprite.position = Utils.get_physic_pos(map_pos)