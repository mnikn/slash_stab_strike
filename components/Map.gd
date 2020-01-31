extends Node

var move_range_rects = []

func init(pos = Vector2(0, 0)):
    $TileMap.position = pos
    Game.connect("game_show_character_move_range", self, "show_character_move_range")
    Game.connect("game_hide_character_move_range", self, "hide_character_move_range")
    
func show_character_move_range(move_range):
    for pos in move_range:
        var rect = ColorRect.new()
        rect.color = Color(0.070588, 0.535172, 0.945098, 0.392157)
        rect.rect_position = Vector2(Game.TILE_SIZE * pos.x, Game.TILE_SIZE * pos.y)
        rect.rect_size = Vector2(Game.TILE_SIZE, Game.TILE_SIZE)
        add_child(rect)
        move_range_rects.push_back(rect)
        
func hide_character_move_range():
    for rect in move_range_rects:
        remove_child(rect)
    move_range_rects = []
    
    