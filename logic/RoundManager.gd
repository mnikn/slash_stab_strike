extends Node

enum CHARACTER_TYPE {
    PLAYER,
    ENEMY
}

class RoundManager:
    var _characters
    var _rounds
    func _init(characters = []):
        self._characters = characters
        self._rounds = []
    func start():
        self.next_round()
    func next_round():
        var new_round = Round.Round.new(self._characters)
        self._rounds.push_back(new_round)
    func get_current_rounds():
        return self._rounds.back()