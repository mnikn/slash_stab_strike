extends Node

class Map:
    var _map = []
    var height = 0
    var width = 0
    func _init(tile_num_x, tile_num_y):
        for i in range(tile_num_x):
            for j in range(tile_num_y):
                var item = MapItem.new(MapPos.new(i, j))
                if i == 0 || i == tile_num_x - 1 || j == 0 || j == tile_num_y - 1:
                    item.terrain_type = TERRAIN_TYPE.BLOCK
                _map.push_back(item)
        height = tile_num_y
        width = tile_num_x
    func get(pos):
        for item in _map:
            if item.pos.equal(pos):
                return item
        return null
    #func set(pos, val):
    #    for i in range(len(_map)):
    #        if _map[i].pos.equal(pos):
    #            _map[i] = val
    #    var item = { "pos": pos, "type": val["type"]}
    #    _map.push_back(item)
#    func find(type):
#        var result = []
#        for item in _map:
#            if item.type == type:
#                result.push_back(item)
#        return result
    func find_by_id(id):
        for item in _map:
            if item.id != null && item.id == id:
                return item
        return null
    func to_string():
        var res = ""
        for item in _map:
            res += "pos: " + item.pos.to_string() + " item: " + str(item.item) + "\n"
        return res
    

class MapPos:
    var x = 0
    var y = 0
    func _init(x = 0, y = 0):
        self.x = x
        self.y = y
    func update(x, y):
        self.x = x
        self.y = y
    func to_string():
        return "x: " + str(self.x) + " y: " + str(self.y) + "\n"
    func hash():
        return hash(self.to_string())
    func equal(pos):
        return self.x == pos.x && self.y == pos.y
    func clone():
        return MapPos.new(self.x, self.y)
        
enum TERRAIN_TYPE {
    PLAIN,
    BLOCK
}

class MapItem:
    var terrain_type
    var item
    var id
    var pos
    func _init(pos = MapPos.new(), type = TERRAIN_TYPE.PLAIN, id = null):
        self.id = id
        self.pos = pos
        self.terrain_type = type