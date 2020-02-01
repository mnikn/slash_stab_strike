extends Node

enum CHARACTER_PART {
    HEAD,
    BODY,
    LEFT_HAND,
    RIGHT_HAND,
    LEFT_LEG,
    RIGHT_LEG    
}

class Character:
    var step
    var attack_range
    func _init():
        self.step = 4
        self.attack_range = 1