extends CanvasLayer

func init(pos = Vector2(0, 0)):
    $Body.position = pos
    hide()

func show():
    $Body.show()
func hide():
    $Body.hide()