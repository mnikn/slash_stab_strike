extends Node

class Cursor:
    var pos
    var _map
    var selected_item
    func _init(map, pos = Map.MapPos.new()):
        self._map = map
        self.pos = pos
    func move_to(target_pos):
        self.pos = target_pos.clone()
    func select(item):
        self.selected_item = item
    func diselect():
        self.selected_item = null