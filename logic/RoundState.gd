extends Node

class RoundState:
    func _init():
        pass

class RoundStateIdle extends RoundState:
    func switch_to_move_selecting(move_range):
        Events.emit_signal("MAP_SHOW_CHARACTER_MOVE_RANGE", move_range.to_array())
        return RoundStateMoveSelecting.new()

class RoundStateActionSelecting extends RoundState:
    func switch_to_idle():
        Events.emit_signal("HIDE_ACTION_PANEL")
        return RoundStateIdle.new()
    func switch_to_attack_selecting(attack_range):
        Events.emit_signal("MAP_SHOW_CHARACTER_ATTACK_RANGE", attack_range.to_array())
        Events.emit_signal("HIDE_ACTION_PANEL")
        return RoundStateAttackSelecting.new()

class RoundStateMoveSelecting extends RoundState:
    func switch_to_idle():
        Events.emit_signal("HIDE_ACTION_PANEL")
        return RoundStateIdle.new()
    func switch_to_action_selecting():
        Events.emit_signal("MAP_HIDE_CHARACTER_MOVE_RANGE")
        Events.emit_signal("SHOW_ACTION_PANEL")
        return RoundStateActionSelecting.new()

class RoundStateAttackSelecting extends RoundState:
    func switch_to_idle():
        Events.emit_signal("HIDE_ACTION_PANEL")
        return RoundStateIdle.new()
    func switch_to_action_selecting():
        Events.emit_signal("MAP_HIDE_CHARACTER_ATTACK_RANGE")
        Events.emit_signal("SHOW_ACTION_PANEL")
        return RoundStateActionSelecting.new()

class RoundStateEnd extends RoundState:
    func _init():
        pass