extends Node

var game
var cursorVisible = false
var cursorActive = false

func _ready():
    game = get_node("/root/Game")

func init(pos = Vector2(0, 0)):
    $Rect.rect_position = pos
    setCursorVisible(true)
    setCursorActive(false)
    
    var cameraNode = self.get_node("Rect/Camera")
    cameraNode.limit_left = 0
    cameraNode.limit_top = 0
    cameraNode.limit_right = get_node("/root/Game").TILE_SIZE * get_node("/root/Game").TILE_NUM_X
    cameraNode.limit_bottom = get_node("/root/Game").TILE_SIZE * get_node("/root/Game").TILE_NUM_Y
    
    game.connect("game_move_cursor", self, "updateCursorPos")
    
func updateCursorPos(tilePos):
    $Rect.set_position(Vector2(tilePos.x * game.TILE_SIZE, tilePos.y * game.TILE_SIZE))
    
func setCursorVisible(visible):
    cursorVisible = visible
    if visible:
        $Rect.show()
    else:
        $Rect.hide()

func setCursorActive(active):
    cursorActive = active
    if active:
        $Rect.color = Color(0.945098, 0.070588, 0.070588, 0.392157)
    else:
        $Rect.color = Color(0.070588, 0.535172, 0.945098, 0.392157)
        
    