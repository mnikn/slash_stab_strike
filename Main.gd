extends Node

var game
var map
var action_panel
func _ready():
    $Map.init(Vector2(0, 0))    
    $AttackPanel.init(Vector2(320, 250))
    $ActionPanel.init(Vector2(570, 30))
    
    game = get_node("/root/Game")
    game.connect("game_show_action_panel", self, "show_action_panel")
    game.connect("game_hide_action_panel", self, "hide_action_panel")
    game.connect("game_show_attack_panel", self, "show_attack_panel")
    game.connect("game_hide_attack_panel", self, "hide_attack_panel")
    game.init()

func show_action_panel():
    $ActionPanel.show()
func hide_action_panel():
    $ActionPanel.hide()
func show_attack_panel():
    $AttackPanel.show()
func hide_attack_panel():
    $AttackPanel.hide()
