extends Node2D

const D_WIDTH  = 20
const D_HEIGHT = 15

const ROOM1 = [
	[1, 1, 1, 1, 1],
	[1, 0, 0, 0, 1],
	[1, 0, 0, 0, 0],
	[1, 0, 0, 0, 1],
	[1, 1, 1, 1, 1],
	]

const ROOM2 = [
	[1, 1, 1, 1, 1],
	[0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0],
	[1, 1, 1, 1, 1],
	]

const ROOM3 = [
	[1, 1, 0, 1, 1],
	[1, 0, 0, 0, 1],
	[0, 0, 0, 0, 0],
	[1, 0, 0, 0, 1],
	[1, 1, 0, 1, 1],
	]

var FLOOR_IDX = 0
var FLOOR_NUM = 5
var WALL_IDX = 5
var WALL_NUM = 2

func _ready():
	generate_dungeon()
	draw_room(ROOM1, 0, 0)
	draw_room(ROOM2, 5, 0)
	draw_room(ROOM3, 5, 5)

func draw_room(room, ox, oy):
	var tilemap = get_node("TileMap")
	var id
	for y in range(room.size()):
		for x in range(room[0].size()):
			if room[y][x] == 0:
				id =  FLOOR_IDX + randi() % FLOOR_NUM
			else:
				id = WALL_IDX + randi() % WALL_NUM
			tilemap.set_cell(ox + x, oy + y, id)

func generate_dungeon():
	var tilemap = get_node("TileMap")
	var tileset = tilemap.get_tileset()
	var tiles_ids = tileset.get_tiles_ids()
	var num_tiles = tiles_ids.size()
	var tile_size = tilemap.get_cell_size().width
	var id
	for x in range(D_WIDTH):
		for y in range(D_HEIGHT):
			id = randi() % num_tiles
			#print(x, ' / ', y, ' / ', id)
			tilemap.set_cell(x, y, id)
