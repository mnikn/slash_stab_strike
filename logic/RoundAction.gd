extends Node

enum ROUND_ACTION {
    NONE,
    MOVE,
    ATTACK,
    WAIT
}
 
class RoundAction:
    var type
#    func undo():
#        printerr("the method need to be implemented!")
#    func process():
#        printerr("the method need to be implemented!")
    
class RoundActionMove extends RoundAction:
    func _init():
        self.type = ROUND_ACTION.MOVE
    func undo(character):
        character.pos = character.initial_pos.clone()
        Events.emit_signal("MAP_MOVE_CHARACTER", character.id, character.pos.clone())
    func process(character, target_pos):
        character.pos = target_pos.clone()        
        Events.emit_signal("MAP_MOVE_CHARACTER", character.id, target_pos.clone())

class RoundActionWait extends RoundAction:
    func _init():
        self.type = ROUND_ACTION.WAIT
    func process():
        pass