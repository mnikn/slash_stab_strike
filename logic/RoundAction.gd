extends Node
 
class RoundAction:
    var type
#    func undo():
#        printerr("the method need to be implemented!")
#    func process():
#        printerr("the method need to be implemented!")
    
class RoundActionMove extends RoundAction:
    func undo(character):
        character.pos = character.initial_pos.clone()
        Events.emit_signal("MAP_MOVE_CHARACTER", character.id, character.pos.clone())
    func process(character, target_pos):
        character.pos = target_pos.clone()        
        Events.emit_signal("MAP_MOVE_CHARACTER", character.id, target_pos.clone())
        
class RoundActionAttack extends RoundAction:
    func process(character, target_character, attack_part):
        pass    
class RoundActionWait extends RoundAction:
    func process():
        pass