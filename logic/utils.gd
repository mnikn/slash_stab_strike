extends Node

var global_id = 0

class Set:
    var _dic = {}
    func append(item):
        self._dic[self._hash(item)] = item
    func remove(item):
        self._dic.erase(self._hash(item))
    func has(item):
        return self._dic.has(self._hash(item))
    func to_array():
        return self._dic.values()
    func clear():
        return self._dic.clear()
    func size():
        return self._dic.size()
    func _hash(item):
        if item is Object && item.has_method("hash"):
            return item.hash()
        return hash(item)
        
func get_physic_pos(map_pos):
    return Vector2(map_pos.x * Game.TILE_SIZE, map_pos.y * Game.TILE_SIZE)
    
func new_id():
    var res = str(global_id + 1)
    global_id += 1
    return res