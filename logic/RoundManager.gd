extends Node

enum CHARACTER_TYPE {
    PLAYER,
    ENEMY
}

class RoundManager:
    var _characters
    var _rounds
    var _map
    func _init(map, characters = {}):
        self._map = map
        self._characters = characters
        self._rounds = []
    func start():
        self.next_round()
    func next_round():
        var new_round = Round.Round.new(self._map, self._characters)
        self._rounds.push_back(new_round)
        Events.emit_signal("MAP_RERENDER", new_round)        
    func get_current_round():
        return self._rounds.back()