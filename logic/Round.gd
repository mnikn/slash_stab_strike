extends Node

enum ROUND_STATE {
    IDLE,
    END
}

enum CHARACTER_ACTION {
    ATTACK,
    WAIT
}

enum CHARACTER_TEAM {
    PLAYER,
    ENEMY
}

class RoundCharacter:
    var info
    var pos
    var team
    var round_state
    var history_action_list
    func _init(character, pos, team):
        self.info = character
        self.pos = pos
        self.team = team
        self.round_state = ROUND_STATE.IDLE
        self.history_action_list = []

class Round:
    var _characters
    func _init(characters = []):
        self._characters = characters
    func character_attack(character_id, target_character_id):
        pass
    func character_move(character_id, target_pos):
        pass
    func character_action_undo(character_id):
        pass
    func show_character_move_range(character_id):
        pass
    func show_character_attack_range(character_id):
        pass