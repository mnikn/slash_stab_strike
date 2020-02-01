extends CanvasLayer

func init(items = []):
    for item in items:
        self.add_item(item) 

func show():
    $List.show()
    
func hide():
    $List.hide()

func add_item(item):
    $List.add_item(item.text, null, false)