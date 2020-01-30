extends Node

func _ready():
    get_node("Game").init()    
    get_node("Map").init()    
    get_node("Cursor").init()
    get_node("Player").init(Vector2(160,160))