extends Node

class Cursor:
    var pos
    var _map
    func _init(map, pos = Map.MapPos.new()):
        self._map = map
        self.pos = pos
    func move_to(target_pos):
        self.pos = target_pos.clone()