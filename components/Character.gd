extends Node

var id

func init(map_pos, character_id):
    var pos = Utils.get_physic_pos(map_pos)
    $Sprite.position = pos
    id = character_id
    
func move_to(map_pos):
    $Sprite.position = Utils.get_physic_pos(map_pos)