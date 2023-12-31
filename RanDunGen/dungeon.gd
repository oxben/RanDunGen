extends Node2D

const D_WIDTH  = 30
const D_HEIGHT = 30

const D_CORRIDOR_CHANCE = 80
const D_DOOR_CHANCE     = 50  

const D_ANYSIDE = 0
const D_NORTH   = 1
const D_EAST    = 2
const D_SOUTH   = 3
const D_WEST    = 4

const D_FLOOR  = 0
const D_WALL   = 1
const D_DIRT   = 2
const D_CORNER = 3
const D_DOORH  = 4
const D_DOORV  = 5

const D_FLOORS = [D_FLOOR, D_DOORH, D_DOORV]

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

const ROOM5 = [
	[2, 2, 2, 2, 2],
	[1, 1, 1, 1, 2],
	[0, 0, 0, 1, 2],
	[1, 1, 0, 1, 2],
	[2, 1, 0, 1, 2],
	]

var rooms = []

var DIRT_IDX  = 0
var DIRT_NUM  = 5
var FLOOR_IDX = 1
var FLOOR_NUM = 6
var WALL_IDX  = 2
var WALL_NUM  = 5
var DOORH_IDX = 3
var DOORH_NUM = 1
var DOORV_IDX = 4
var DOORV_NUM = 1

class Room:
	var _size = 0: get = get_size
	var _tiles = []: get = get_tiles, set = set_tiles
	var _portals = null

	func _init(tiles):
		set_tiles(tiles)
		set_portals()

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
		set_portals()

	func set_portals():
		var portals = {
			D_NORTH : [],
			D_EAST : [],
			D_SOUTH : [],
			D_WEST : []
		}
		var x1  # start column for scan
		var y1  # start line for scan
		# North
		y1 = 1
		for x in range(1, _size-1):
			if _tiles[y1][x] == 0:
				portals[D_NORTH].append([x,y1])
		# South
		y1 = _size - 2
		for x in range(1, _size-1):
			if _tiles[y1][x] == 0:
				portals[D_SOUTH].append([x,y1])
		x1 = 1
		# East
		for y in range(1, _size-1):
			if _tiles[y][x1] == 0:
				portals[D_EAST].append([x1,y])
		x1 = _size - 2
		# West
		for y in range(1, _size-1):
			if _tiles[y][x1] == 0:
				portals[D_WEST].append([x1,y])
		# Set portals
		_portals = portals

	func get_portals():
		# Return a deep copy of _portals
		return str_to_var( var_to_str( _portals ) )

func _ready():
	set_process_input(true)
	get_node("SeedEdit").text = "0"
	get_node("RoomEdit").text = "8"
	generate_dungeon_3(0, 8)
#    rooms.append(Room.new(ROOM1))
#    rooms.append(Room.new(ROOM2))
#    rooms.append(Room.new(ROOM3))
#    rooms.append(Room.new(ROOM4))
#    rooms.append(Room.new(ROOM5))
#
#    draw_room(rooms[0], 0, 0)
#    rooms[0].rotate(90)
#    draw_room(rooms[0], 5, 0)
#    rooms[0].rotate(180)
#    draw_room(rooms[0], 10, 0)
#    rooms[0].rotate(270)
#    draw_room(rooms[0], 15, 0)

func _input(event):
	#if event.type == InputEvent.KEY:
	if Input.is_action_pressed("quit_game"):
		get_tree().quit()
		return
	if Input.is_action_pressed("gen_dungeon"):
		# Generate random seed
		var dungeon_seed = randi()
		get_node("SeedEdit").text = str(dungeon_seed)
		# Generate dungeon
		generate_dungeon_3(dungeon_seed, get_node("RoomEdit").text.to_int())
		return

func _on_SeedEdit_text_entered(new_text):
	generate_dungeon_3(new_text.to_int(), get_node("RoomEdit").text.to_int())
	get_node("SeedEdit").release_focus()

func _on_RoomEdit_text_entered(new_text):
	generate_dungeon_3(get_node("SeedEdit").text.to_int(), new_text.to_int())
	get_node("RoomEdit").release_focus()

func draw_tilemap(room, ox, oy):
	var tiles = room.get_tiles()
	var tilemap = get_node("TileMap")
	var tile = Vector2i(0, 0) # tile coords
	for y in range(room.get_size()):
		for x in range(room.get_size()):
			if tiles[y][x] == D_FLOOR:
				tile.x = FLOOR_IDX
				tile.y = randi() % FLOOR_NUM
			elif tiles[y][x] == D_WALL or tiles[y][x] == D_CORNER:
				tile.x = WALL_IDX
				tile.y = randi() % WALL_NUM
			elif tiles[y][x] == D_DOORH:
				tile.x = DOORH_IDX
				tile.y = 0
			elif tiles[y][x] == D_DOORV:
				tile.x = DOORV_IDX
				tile.y = 0
			else:
				tile.x = DIRT_IDX
				tile.y = randi() % DIRT_NUM
			var pos = Vector2i(ox + x, oy + y)
			tilemap.set_cell(0, pos, 0, tile)

func generate_dungeon():
	var tilemap = get_node("TileMap")
	var tileset = tilemap.get_tileset()
	var tiles_ids = tileset.get_tiles_ids()
	var num_tiles = tiles_ids.size()
	var tile_size = tilemap.get_cell_size().length()
	var id
	for x in range(D_WIDTH):
		for y in range(D_HEIGHT):
			id = randi() % num_tiles
			tilemap.set_cell(x, y, id)

func generate_dungeon_2():
	var id
	var room = null
	var portals = null
	var prev_room = null
	var prev_portals = null

	for x in range(D_WIDTH/5):
		for y in range(D_HEIGHT/5):
			var found = false
			var count = 0
			while count < 5:
				id = randi() % rooms.size()
				room = rooms[id]
				if prev_room != null:
					portals = room.get_portals()
					if portals[D_WEST] == prev_portals[D_EAST]:
						break
					elif portals[D_SOUTH] == prev_portals[D_EAST]:
						room.rotate(90)
						break
					elif portals[D_SOUTH] == prev_portals[D_EAST]:
						room.rotate(180)
						break
					elif portals[D_NORTH] == prev_portals[D_EAST]:
						room.rotate(270)
						break
					else:
						count += 1
				else:
					break
			draw_tilemap(rooms[id], x * 5, y * 5)
			prev_portals = portals

func alloc_array(width, height):
	var a = []
	a.resize(height)
	for y in range(height):
		var b = []
		for x in range(width):
			b.append(D_DIRT)
		a[y] = b
	return a

func fill_box(a, x, y, w, h, tile_type):
	for i in range(y, y+h):
		for j in range(x, x+w):
			a[i][j] = tile_type

func draw_walls(a, w, h):
	var prev = -1
	var curr = -1
	var next = -1
	# detect wall locations by scanning vertically 
	for y in range(h):
		for x in range(w):
			curr = a[y][x]
			if curr in D_FLOORS and prev == D_DIRT:
				a[y][x-1] = D_WALL
			elif curr == D_DIRT and prev in D_FLOORS:
				a[y][x] = D_WALL
			prev = a[y][x]
	# detect wall locations by scanning horizontally 
	prev = -1
	for x in range(w):
		for y in range(h):
			curr = a[y][x]
			if curr in D_FLOORS and prev == D_DIRT:
				a[y-1][x] = D_WALL
			elif curr == D_DIRT and prev in D_FLOORS:
				a[y][x] = D_WALL
			prev = a[y][x]
	# Add corners
	prev = -1
	for y in range(h):
		for x in range(w):
			if a[y][x] == D_WALL and prev == D_DIRT:
				if a[y-1][x] == D_FLOOR or a[y+1][x] in D_FLOORS:
					a[y][x-1] = D_CORNER
			elif a[y][x] == D_DIRT and prev == D_WALL:
				if a[y-1][x-1] in D_FLOORS or a[y+1][x-1] in D_FLOORS:
					a[y][x] = D_CORNER
			prev = a[y][x]
	# Remove doors with no walls on both side
	prev = -1
	for y in range(h):
		for x in range(w):
			if a[y][x] == D_DOORV:
				prev = a[y-1][x] if y > 0 else -1
				next = a[y+1][x] if y < h-1 else -1
				if  prev != D_WALL or next != D_WALL:
					a[y][x] = D_FLOOR
			elif a[y][x] == D_DOORH:
				prev = a[y][x-1] if x > 0 else -1
				next = a[y][x+1] if x < w-1 else -1
				if  prev != D_WALL or next != D_WALL:
					a[y][x] = D_FLOOR
 

func dig_corridors(a, aw, ah, rx, ry, rw, rh):
	# Each room has a 50% chance in each direction to have a corridor
	var x
	var y
	var l
	# North wall
	if ((randi() % 100) < D_CORRIDOR_CHANCE):
		l = randi() % ry
		x = rx + (randi() % rw)
		y = ry - l
		for idx in range(l):
			if a[y+idx][x] != D_FLOOR:
				if l >= 2 and idx == (l-1):
					a[y+idx][x] = D_DOORH
				else:
					a[y+idx][x] = D_FLOOR
			else:
				break
	# South wall
	if ((randi() % 100) < D_CORRIDOR_CHANCE):
		x = rx + (randi() % rw)
		y = ry + rh
		l = randi() % (ah - y)
		for idx in range(l):
			if a[y+idx][x] != D_FLOOR:
				if l >= 2 and idx == 0:
					a[y+idx][x] = D_DOORH
				else:
					a[y+idx][x] = D_FLOOR
			else:
				break
	# East wall
	if ((randi() % 100) < D_CORRIDOR_CHANCE):
		x = rx + rw
		y = ry + (randi() % rh)
		l = randi() % (aw - x)
		for idx in range(l):
			if a[y][x+idx] != D_FLOOR:
				if l >= 2 and idx == 0:
					a[y][x+idx] = D_DOORV
				else:
					a[y][x+idx] = D_FLOOR
			else:
				break
	# West wall
	if ((randi() % 100) < D_CORRIDOR_CHANCE):
		l = randi() % rx
		x = rx - l
		y = ry + (randi() % rh)
		for idx in range(l):
			if a[y][x+idx] != D_FLOOR:
				if l >= 2 and idx == (l-1):
					a[y][x+idx] = D_DOORV
				else:
					a[y][x+idx] = D_FLOOR
			else:
				break

func generate_dungeon_3(dungeon_seed, room_num = 8):
	seed(dungeon_seed)
	var dungeon = alloc_array(D_WIDTH, D_HEIGHT)
	for idx in range(room_num):
		var x = min(1 + randi() % (D_WIDTH-1), D_HEIGHT-8-1)
		var y = min(1 + randi() % (D_WIDTH-1), D_HEIGHT-8-1)
		var width = 2 + randi() % 6
		var height = 2 + randi() % 6
		print(x, '/', y, '/', width, '/', height)
		fill_box(dungeon, x, y, width, height, D_FLOOR)
		dig_corridors(dungeon, D_WIDTH, D_HEIGHT, x, y, width, height)
	draw_walls(dungeon, D_WIDTH, D_HEIGHT)
	var room = Room.new(dungeon)
	draw_tilemap(room, 0, 0)

