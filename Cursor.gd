extends Node

var cursorVisible = false
var cursorActive = false

func _input(event):
    if !(event is InputEventKey) || !cursorVisible:
        return
    var cameraNode = self.get_node("Rect/Camera")
    var currentRectPos = $Rect.rect_position
    
    var xDirection = event.get_action_strength("move_right") - event.get_action_strength("move_left")
    var yDirection = event.get_action_strength("move_down") - event.get_action_strength("move_up")
    # fixme: modifier not work
    var moveTileNum = 5 if event.is_action_pressed("shift_modifer") else 1
    if xDirection != 0:
        var nextX = currentRectPos.x - (get_node("/root/Game").TILE_SIZE * moveTileNum) if xDirection < 0 else currentRectPos.x + (get_node("/root/Game").TILE_SIZE * moveTileNum)
        nextX = clamp(nextX, cameraNode.limit_left, cameraNode.limit_right - get_node("/root/Game").TILE_SIZE)
        $Rect.set_position(Vector2(nextX, currentRectPos.y))
    if yDirection != 0:
        var nextY = currentRectPos.y - (get_node("/root/Game").TILE_SIZE * moveTileNum) if yDirection < 0 else currentRectPos.y + (get_node("/root/Game").TILE_SIZE * moveTileNum)
        nextY = clamp(nextY, cameraNode.limit_top, cameraNode.limit_bottom - get_node("/root/Game").TILE_SIZE)
        $Rect.set_position(Vector2(currentRectPos.x, nextY))

func init(pos = Vector2(0, 0)):
    $Rect.rect_position = pos
    setCursorVisible(true)
    setCursorActive(false)
    
    var cameraNode = self.get_node("Rect/Camera")
    cameraNode.limit_left = 0
    cameraNode.limit_top = 0
    cameraNode.limit_right = get_node("/root/Game").TILE_SIZE * get_node("/root/Game").TILE_NUM_X
    cameraNode.limit_bottom = get_node("/root/Game").TILE_SIZE * get_node("/root/Game").TILE_NUM_Y
    
    # connect("game_cursor_active", self, "setCursorActive")
    # get_node("/root/Main/Game")
    
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
        
    