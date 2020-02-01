extends Node

signal MAP_RERENDER(latest_round)
signal MAP_SHOW_CHARACTER_MOVE_RANGE(move_range)
signal MAP_HIDE_CHARACTER_MOVE_RANGE(move_range)
signal MAP_SHOW_CHARACTER_ATTACK_RANGE(attack_range)
signal MAP_HIDE_CHARACTER_ATTACK_RANGE(attack_range)
signal MAP_MOVE_CHARACTER(character_id, move_pos)
signal MAP_MOVE_CURSOR(map_pos)

signal SHOW_ACTION_PANEL()
signal HIDE_ACTION_PANEL()
signal SHOW_ATTACK_PANEL()
signal HIDE_ATTACK_PANEL()