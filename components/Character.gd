extends Node

var character

func init(character):
    var pos = Utils.get_physic_pos(character.pos)
    $Sprite.position = pos
    self.character = character
    
func move_to(map_pos):
    $Sprite.position = Utils.get_physic_pos(map_pos)