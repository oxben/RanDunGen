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

const ROOM4 = [
	[2, 2, 2, 2, 2],
	[1, 1, 1, 1, 1],
	[0, 0, 0, 0, 0],
	[1, 1, 1, 1, 1],
	[2, 2, 2, 2, 2],
	]

var rooms = []

var DIRT_IDX = 0
var DIRT_NUM = 1
var FLOOR_IDX = DIRT_IDX + DIRT_NUM
var FLOOR_NUM = 5
var WALL_IDX = FLOOR_IDX + FLOOR_NUM
var WALL_NUM = 2

class Room:
	var _size = 0 setget , get_size
	var _tiles = [] setget set_tiles, get_tiles

	func _init(tiles):
		set_tiles(tiles)

	func get_tiles():
		return _tiles

	func set_tiles(tiles):
		_tiles = tiles
		_size = _tiles[0].size()

	func get_size():
		return _size

	func transpose():
		var tmp
		for n in range(0, _size-1):
			for m in range(n + 1, _size):
				tmp = _tiles[n][m]
				_tiles[n][m] = _tiles[m][n]
				_tiles[m][n] = tmp

	func mirror_x():
		var tmp
		for y in range(_size):
			for x in range(_size/2):
				tmp = _tiles[y][x]
				_tiles[y][x] = _tiles[y][_size-1-x]
				_tiles[y][_size-1-x] = tmp

	func mirror_y():
		var tmp
		for y in range(_size/2):
			tmp = _tiles[y]
			_tiles[y] = _tiles[_size-1-y]
			_tiles[_size-1-y] = tmp

	func rotate(angle):
		if angle % 90 != 0 or angle == 0:
			return
		if angle == 90:
			transpose()
			mirror_x()
		elif angle == 180:
			mirror_x()
			mirror_y()
		elif angle == 270:
			transpose()
			mirror_y()

func _ready():
	set_process_input(true)
	generate_dungeon()
	rooms.append(Room.new(ROOM1))
	rooms.append(Room.new(ROOM2))
	rooms.append(Room.new(ROOM3))
	rooms.append(Room.new(ROOM4))

	draw_room(rooms[0], 0, 0)
	rooms[0].rotate(90)
	draw_room(rooms[0], 5, 0)
	rooms[0].rotate(180)
	draw_room(rooms[0], 10, 0)
	rooms[0].rotate(270)
	draw_room(rooms[0], 15, 0)

func _input(event):
	#if event.type == InputEvent.KEY:
	if Input.is_action_pressed("quit_game"):
		get_tree().quit()
		return
	if Input.is_action_pressed("gen_dungeon"):
		generate_dungeon_2()
		return

func draw_room(room, ox, oy):
	var tiles = room.get_tiles()
	var tilemap = get_node("TileMap")
	var id
	for y in range(room.get_size()):
		for x in range(room.get_size()):
			if tiles[y][x] == 0:
				id =  FLOOR_IDX + randi() % FLOOR_NUM
			elif tiles[y][x] == 1:
				id = WALL_IDX + randi() % WALL_NUM
			else:
				id = DIRT_IDX + randi() % DIRT_NUM
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
			tilemap.set_cell(x, y, id)

func generate_dungeon_2():
	var id
	for x in range(D_WIDTH/5):
		for y in range(D_HEIGHT/5):
			id = randi() % rooms.size()
			draw_room(rooms[id], x * 5, y * 5)

