extends Node

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
    func _hash(item):
        if item is Object && item.has_method("hash"):
            return item.hash()
        return hash(item)