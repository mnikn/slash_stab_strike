extends Node

func init(pos = Vector2(0, 0)):
    $TileMap.position = pos
    get_node("/root/Game").connect("game_toggle_character_move_range", self, "toggle_character_move_range")

func toggle_character_move_range(move_range):
    for pos in move_range:
        var rect = ColorRect.new()
        rect.color = Color(0.070588, 0.535172, 0.945098, 0.392157)
        rect.rect_position = Vector2(Game.TILE_SIZE * pos.x, Game.TILE_SIZE * pos.y)
        rect.rect_size = Vector2(Game.TILE_SIZE, Game.TILE_SIZE)
        add_child(rect)
    