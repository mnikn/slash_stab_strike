extends Node

func _ready():
    get_node("/root/Game").init()    
    $Map.init()    
    $Cursor.init()
    $Character.init(Vector2(160,160))