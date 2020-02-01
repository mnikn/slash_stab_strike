extends Node

func _ready():
    $Map.init(Vector2(0, 0))    
    $AttackPanel.init(Vector2(320, 250))
    $ActionPanel.init(Vector2(570, 30))
    
    Events.connect("SHOW_ACTION_PANEL", self, "show_action_panel")
    Events.connect("HIDE_ACTION_PANEL", self, "hide_action_panel")
    Events.connect("SHOW_ATTACK_PANEL", self, "show_attack_panel")
    Events.connect("HIDE_ATTACK_PANEL", self, "hide_attack_panel")
    Game.init()

func show_action_panel():
    $ActionPanel.show()
func hide_action_panel():
    $ActionPanel.hide()
func show_attack_panel():
    $AttackPanel.show()
func hide_attack_panel():
    $AttackPanel.hide()
