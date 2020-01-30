extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.

const TILE_SIZE = 16
const TILE_NUM_X = 30
const TILE_NUM_Y = 30

func _ready():
    var cameraNode = self.get_node("Rect/Camera")
    cameraNode.limit_left = 0
    cameraNode.limit_top = 0
    cameraNode.limit_right = TILE_SIZE * TILE_NUM_X
    cameraNode.limit_bottom = TILE_SIZE * TILE_NUM_Y

func _input(event):
    if !(event is InputEventKey):
        return
    var rectNode = self.get_node("Rect")
    var cameraNode = self.get_node("Rect/Camera")
    var currentRectPos = rectNode.rect_position
    
    var xDirection = event.get_action_strength("move_right") - event.get_action_strength("move_left")
    var yDirection = event.get_action_strength("move_down") - event.get_action_strength("move_up")
    # fixme: modifier not work
    var moveTileNum = 5 if event.is_action_pressed("shift_modifer") else 1
    if xDirection != 0:
        var nextX = currentRectPos.x - (TILE_SIZE * moveTileNum) if xDirection < 0 else currentRectPos.x + (TILE_SIZE * moveTileNum)
        nextX = clamp(nextX, cameraNode.limit_left, cameraNode.limit_right - TILE_SIZE)
        rectNode.set_position(Vector2(nextX, currentRectPos.y))
    if yDirection != 0:
        var nextY = currentRectPos.y - (TILE_SIZE * moveTileNum) if yDirection < 0 else currentRectPos.y + (TILE_SIZE * moveTileNum)
        nextY = clamp(nextY, cameraNode.limit_top, cameraNode.limit_bottom - TILE_SIZE)
        rectNode.set_position(Vector2(currentRectPos.x, nextY))