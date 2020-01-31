extends Node

class Character:
    var id
    var _map
    var pos
    var _step
    var active
    func _init(map, pos = Map.MapPos.new()):
        _map = map
        _step = 4
        self.pos = pos
    func move_to(target_pos):
        var next_pos = target_pos.clone()
        _map.get(self.pos).item = null
        _map.get(next_pos).item = self
        self.pos = next_pos
    func get_move_range():
        var move_range = _do_get_move_range(pos, _step, Utils.Set.new())       
        move_range.remove(pos)
        return move_range
    func _do_get_move_range(current_pos, limit_step, results):
        if (limit_step < 0 || 
            current_pos.x < 0 || 
            current_pos.x >= _map.width || 
            current_pos.y < 0 || 
            current_pos.y >= _map.height):
            return results
        if self._map.get(current_pos).terrain_type == Map.TERRAIN_TYPE.BLOCK:
            return results
        results.append(current_pos)
        _do_get_move_range(Map.MapPos.new(current_pos.x + 1, current_pos.y), limit_step - 1, results)
        _do_get_move_range(Map.MapPos.new(current_pos.x - 1, current_pos.y), limit_step - 1, results)
        _do_get_move_range(Map.MapPos.new(current_pos.x, current_pos.y + 1), limit_step - 1, results)
        _do_get_move_range(Map.MapPos.new(current_pos.x, current_pos.y - 1), limit_step - 1, results)
        return results
    func set_active(active):
        self.active = active