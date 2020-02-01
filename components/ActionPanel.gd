extends Node

func init(pos = Vector2(0, 0)):
    $VBoxContainer.rect_position = pos
    $VBoxContainer/AttackButton.connect("pressed", self, "on_attack_btn_press")
    $VBoxContainer/WaitButton.connect("pressed", self, "on_wait_btn_press")
    
    hide()

func show():
    $VBoxContainer.show()
func hide():
    $VBoxContainer.hide()

func on_attack_btn_press():
    Game.emit_signal("game_action_attack")
    Game.emit_signal("game_hide_action_panel")
func on_wait_btn_press():
    Game.emit_signal("game_action_wait")    
    Game.emit_signal("game_hide_action_panel")