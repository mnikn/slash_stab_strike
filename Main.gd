extends Node

var game
var map
var action_panel
func _ready():
    game = get_node("/root/Game")
    game.connect("game_init_map", self, "create_map")  
    game.connect("game_create_attack_panel", self, "create_attack_panel")
    game.connect("game_create_action_panel", self, "create_action_panel")
    game.connect("game_destory_action_panel", self, "destory_action_panel")    
    game.init()

func create_map():
    map = load("res://components/Map.tscn").instance()
    add_child(map)
    map.init(Vector2(0, 0))

func create_attack_panel():
    var attack_panel = load("res://components/AttackPanel.tscn").instance()
    add_child(attack_panel)
    attack_panel.init(Vector2(320, 250))

func create_action_panel():
    action_panel = load("res://components/ActionPanel.tscn").instance()
    add_child(action_panel)
    action_panel.init(Vector2(570, 30))
func destory_action_panel():
    remove_child(action_panel)
