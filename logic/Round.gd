extends Node

enum CHARACTER_TEAM {
    PLAYER,
    ENEMY
}

class RoundCharacter:
    var id
    var info
    var initial_pos
    var pos
    var team
    var round_state
    var history_actions
    func _init(character, pos, team):
        self.id = Utils.new_id()
        self.info = character
        self.pos = pos
        self.team = team
        self.round_state = RoundState.RoundStateIdle.new()
        self.history_actions = []
        self.initial_pos = pos
        
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
            if (character.round_state is RoundState.RoundStateActionSelecting ||
                character.round_state is RoundState.RoundStateAttackSelecting || 
                character.round_state is RoundState.RoundStateMoveSelecting ||
                character.round_state is RoundState.RoundStateAttackPartSelecting):
                return character
        return null
        
    func show_attack_part(character_id, target_pos):
        var character = self.get_character(character_id)
        if !(character.round_state is RoundState.RoundStateAttackSelecting):
            return
        var target_character = self.get_character_by_pos(target_pos)
        if target_character == null:
            return
        var attack_range = self.get_character_attack_range(character_id)
        if attack_range.has(target_pos):
            character.round_state = character.round_state.switch_to_attack_part_selecting(target_character)
    func attack_character(character_id, target_character_id, attack_part):
        var character = self.get_character(character_id)
        var target_character = self.get_character(target_character_id)
        if target_character == null || !(character.round_state is RoundState.RoundStateAttackPartSelecting):
            return
        var action = RoundAction.RoundActionAttack.new()
        action.process(character, target_character, attack_part)
        character.history_actions.push_back(action)
        character.round_state = character.round_state.switch_to_end()
    func character_action_undo(character_id):
        var character = self.get_character(character_id)
        var recent_action = character.history_actions.back()
        if recent_action != null:
            recent_action.undo(character)
            character.history_actions.pop_back()
    func cancel_action():
        var character = self.get_selecting_character()
        if character != null && !(character.round_state is RoundState.RoundStateEnd):
            if character.round_state is RoundState.RoundStateActionSelecting:
                self.character_action_undo(character.id)
                character.round_state = character.round_state.switch_to_idle()
            elif character.round_state is RoundState.RoundStateAttackSelecting:
                character.round_state = character.round_state.switch_to_action_selecting()
    func show_character_move_range(character_id):
        var character = self.get_character(character_id)
        if !(character.round_state is RoundState.RoundStateIdle):
            return
        var move_range = self.get_character_move_range(character_id)
        character.round_state = character.round_state.switch_to_move_selecting(move_range)
    func move_character(character_id, target_pos):
        var character = self.get_character(character_id)
        if !(character.round_state is RoundState.RoundStateMoveSelecting):
            return
        var move_range = self.get_character_move_range(character_id)
        if move_range.has(target_pos):
            var move_action = RoundAction.RoundActionMove.new()
            move_action.process(character, target_pos)
            character.history_actions.append(move_action)
            
            character.round_state = character.round_state.switch_to_action_selecting()
            
    func show_character_attack_range():
        var character = self.get_selecting_character()
        if character == null || !(character.round_state is RoundState.RoundStateActionSelecting):
            return
        var attack_range = self.get_character_attack_range(character.id)
        character.round_state = character.round_state.switch_to_attack_selecting(attack_range)
        
    func character_wait():
        var character = self.get_selecting_character()
        if character == null || !(character.round_state is RoundState.RoundStateActionSelecting):
            return
        var action = RoundAction.RoundActionWait.new()
        action.process()
        character.history_actions.append(action)
        character.round_state = character.round_state.switch_to_idle()

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