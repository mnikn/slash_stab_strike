extends Node

func _ready():
    $Map.init(Vector2(0, 0))
    
    var attack_option_press_callback = funcref(Game, 'on_attack_option_press')
    var attack_options = [{
        "label": "Head",
        "id": Character.CHARACTER_PART.HEAD,
        "callback": attack_option_press_callback
    },{
        "label": "Body",
        "id": Character.CHARACTER_PART.BODY,
        "callback": attack_option_press_callback        
    },{
        "label": "Left hand",
        "id": Character.CHARACTER_PART.LEFT_HAND,
        "callback": attack_option_press_callback
    },{
        "label": "Right hand",
        "id": Character.CHARACTER_PART.RIGHT_HAND,
        "callback": attack_option_press_callback             
    },{
        "label": "Left leg",
        "id": Character.CHARACTER_PART.LEFT_LEG,
        "callback": attack_option_press_callback
    },{
        "label": "Right leg",
        "id": Character.CHARACTER_PART.RIGHT_HAND,
        "callback": attack_option_press_callback  
    }]
    $AttackPanel.init(attack_options)
    
    var action_option_press_callback = funcref(Game, 'on_action_option_press')    
    var action_options = [{
        "label": "Attack",
        "id": Character.CHARACTER_ACTION.ATTACK,
        "callback": action_option_press_callback
    }, {
        "label": "Wait",
        "id": Character.CHARACTER_ACTION.WAIT,
        "callback": action_option_press_callback
    }, {
        "label": "Canel",
        "id": Character.CHARACTER_ACTION.CANCEL,
        "callback": action_option_press_callback
    }]
    $ActionPanel.init(action_options)
    
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
