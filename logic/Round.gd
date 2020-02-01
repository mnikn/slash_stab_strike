extends Node

enum CHARACTER_ROUND_STATE {
    IDLE,
    ACTION_SELECTING,    
    MOVE_SELECTING,
    ATTACK_SELECTING
    END
}

enum CHARACTER_ACTION {
    MOVE,    
    ATTACK,
    WAIT
}

enum CHARACTER_TEAM {
    PLAYER,
    ENEMY
}

class RoundCharacter:
    var id
    var info
    var pos
    var team
    var round_state
    var history_action_list
    func _init(character, pos, team):
        self.id = Utils.new_id()
        self.info = character
        self.pos = pos
        self.team = team
        self.round_state = CHARACTER_ROUND_STATE.IDLE
        self.history_action_list = []
        
class Round:
    var _map
    var characters
    func _init(map, characters = {}):
        self._map = map
        self.characters = characters
        Events.connect("ACTION_ATTACK_PRESS", self, "show_character_attack_range")
        Events.connect("ACTION_WAIT_PRESS", self, "character_wait")
    func get_character(id):
        return self.characters[id]
    func get_character_by_pos(pos):
        for character in self.characters.values():
            if character.pos.equal(pos):
                return character
        return null
    func get_selecting_character():
        for character in self.characters.values():
            if (character.round_state == CHARACTER_ROUND_STATE.ACTION_SELECTING ||
                character.round_state == CHARACTER_ROUND_STATE.MOVE_SELECTING || 
                character.round_state == CHARACTER_ROUND_STATE.ATTACK_SELECTING):
                return character
        return null
        
    func character_attack(character_id, target_character_id):
        pass
    func character_move(character_id, target_pos):
        pass
    func character_action_undo(character_id):
        pass
    func show_character_move_range(character_id):
        var character = self.get_character(character_id)
        if character.round_state != CHARACTER_ROUND_STATE.IDLE:
            return
        var move_range = self.get_character_move_range(character_id)
        Events.emit_signal("MAP_SHOW_CHARACTER_MOVE_RANGE", move_range.to_array())
        character.round_state = CHARACTER_ROUND_STATE.MOVE_SELECTING
    func move_character(character_id, target_pos):
        var character = self.get_character(character_id)
        if character.round_state != CHARACTER_ROUND_STATE.MOVE_SELECTING:
            return
        var move_range = self.get_character_move_range(character_id)
        if move_range.has(target_pos):
            Events.emit_signal("MAP_MOVE_CHARACTER", character.id, target_pos.clone())
            Events.emit_signal("MAP_HIDE_CHARACTER_MOVE_RANGE")
            Events.emit_signal("SHOW_ACTION_PANEL")
            character.pos = target_pos.clone()
            character.round_state = CHARACTER_ROUND_STATE.ACTION_SELECTING
            character.history_action_list.append({"type": CHARACTER_ACTION.MOVE, "target_pos": target_pos})
    func show_character_attack_range():
        var character = self.get_selecting_character()
        if character == null || character.round_state != CHARACTER_ROUND_STATE.ACTION_SELECTING:
            return
        var attack_range = self.get_character_attack_range(character.id)
        Events.emit_signal("MAP_SHOW_CHARACTER_ATTACK_RANGE", attack_range.to_array())
        Events.emit_signal("HIDE_ACTION_PANEL")
        
    func character_wait():
        var character = self.get_selecting_character()
        if character == null || character.round_state != CHARACTER_ROUND_STATE.ACTION_SELECTING:
            return
        character.round_state = CHARACTER_ROUND_STATE.IDLE
        character.history_action_list.append({"type": CHARACTER_ACTION.WAIT})
        Events.emit_signal("HIDE_ACTION_PANEL")

    func get_character_move_range(character_id):
        var character = self.get_character(character_id)
        return self._do_get_range(character, character.pos, character.info.step, Utils.Set.new(), "_filter_character")
    func get_character_attack_range(character_id):
        var character = self.get_character(character_id)
        var attack_range = self._do_get_range(character, character.pos, character.info.attack_range, Utils.Set.new())
        attack_range.remove(character.pos)
        return attack_range
    func _do_get_range(character, current_pos, limit_step, results, custom_filter = null):
        if (limit_step < 0 || 
            current_pos.x < 0 || 
            current_pos.x >= _map.width || 
            current_pos.y < 0 || 
            current_pos.y >= _map.height):
            return results
        if self._map.get(current_pos).terrain_type == Map.TERRAIN_TYPE.BLOCK || (custom_filter != null && call(custom_filter, character, current_pos)):
            return results
        results.append(current_pos)
        self._do_get_range(character, Map.MapPos.new(current_pos.x + 1, current_pos.y), limit_step - 1, results, custom_filter)
        self._do_get_range(character, Map.MapPos.new(current_pos.x - 1, current_pos.y), limit_step - 1, results, custom_filter)
        self._do_get_range(character, Map.MapPos.new(current_pos.x, current_pos.y + 1), limit_step - 1, results, custom_filter)
        self._do_get_range(character, Map.MapPos.new(current_pos.x, current_pos.y - 1), limit_step - 1, results, custom_filter)
        return results
    func _filter_character(character, current_pos):
        return !current_pos.equal(character.pos) && self.get_character_by_pos(current_pos) != null