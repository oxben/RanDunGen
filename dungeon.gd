extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	generate_dungeon()

func generate_dungeon():
	var tilemap = get_node("TileMap")
	var tileset = tilemap.get_tileset()
	var tiles_ids = tileset.get_tiles_ids()
	var num_tiles = tiles_ids.size()
	var tile_size = tilemap.get_cell_size().width
	for x in range(10):
		for y in range(10):
			var id = randi() % num_tiles
			print(x, y, id)
			tilemap.set_cell(x, y, id)

