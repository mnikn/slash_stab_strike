extends Node

func _ready():
    get_node("Cursor").init()
    get_node("Map").init()
    # var root = get_tree().get_root()
    # root.connect("size_changed", self, "resize")
    # OS.set_window_fullscreen(true)