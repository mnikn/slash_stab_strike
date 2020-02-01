extends Node

enum CHARACTER_TYPE {
    PLAYER,
    ENEMY
}

enum CHARACTER_ACTION_STATE {
    ATTACK,
    WAIT,
    IDLE
}

class Character:
    var id
    var _map
    var pos
    var _step
    var _attack_range
    var active
    var type
    var action_state
    func _init(map, pos = Map.MapPos.new()):
        self._map = map
        self.pos = pos
        self._step = 4
        self._attack_range = 1    
        self.type = CHARACTER_TYPE.PLAYER
        self.action_state = CHARACTER_ACTION_STATE.IDLE
    func move_to(target_pos):
        var next_pos = target_pos.clone()
        _map.get(self.pos).item = null
        _map.get(next_pos).item = self
        self.pos = next_pos
    func set_active(active):
        self.active = active
    func switch_to_state(state):
        self.action_state = state
    func get_move_range():
        var move_range = self._do_get_range(pos, _step, Utils.Set.new(), "_filter_character")
        return move_range
    func get_attack_range():
        var attack_range = self._do_get_range(self.pos, self._attack_range, Utils.Set.new())
        attack_range.remove(self.pos)
        return attack_range
    func _do_get_range(current_pos, limit_step, results, custom_filter = null):
        if (limit_step < 0 || 
            current_pos.x < 0 || 
            current_pos.x >= _map.width || 
            current_pos.y < 0 || 
            current_pos.y >= _map.height):
            return results
        if self._map.get(current_pos).terrain_type == Map.TERRAIN_TYPE.BLOCK || (custom_filter != null && call(custom_filter, current_pos)):
            return results
        results.append(current_pos)
        self._do_get_range(Map.MapPos.new(current_pos.x + 1, current_pos.y), limit_step - 1, results, custom_filter)
        self._do_get_range(Map.MapPos.new(current_pos.x - 1, current_pos.y), limit_step - 1, results, custom_filter)
        self._do_get_range(Map.MapPos.new(current_pos.x, current_pos.y + 1), limit_step - 1, results, custom_filter)
        self._do_get_range(Map.MapPos.new(current_pos.x, current_pos.y - 1), limit_step - 1, results, custom_filter)
        return results
    func _filter_character(current_pos):
        return !current_pos.equal(self.pos) && self._map.get(current_pos).item is Character