extends CanvasLayer

var items

func init(items = []):
    self.items = items
    for item in items:
        self.add_item(item)
    $Container.connect("id_pressed", self, "on_item_press")    

func show():
    $Container.show()
    
func hide():
    $Container.hide()

func add_item(item):
    $Container.add_item(item.label, item.id)
    
func on_item_press(id):
    for item in self.items:
        if item.id == id && item.callback != null:
            item.callback.call_func(item.id)