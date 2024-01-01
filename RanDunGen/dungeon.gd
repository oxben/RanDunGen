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

const D_VOID   = -1
const D_FLOOR  =  0
const D_WALL   =  1
const D_DIRT   =  2
const D_CORNER =  3
const D_DOORH  =  4
const D_DOORV  =  5

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


const WALL_DEFAULT = [ # Default wall feature
	[D_VOID, D_VOID, D_VOID],
	[D_VOID, D_WALL, D_VOID],
	[D_VOID, D_VOID, D_VOID],
]

const WALL_WEST = [
	[D_VOID, D_VOID, D_VOID],
	[D_VOID, D_WALL, D_FLOOR],
	[D_VOID, D_VOID, D_VOID],
]

const WALL_EAST = [
	[D_VOID, D_VOID, D_VOID],
	[D_FLOOR, D_WALL, D_VOID],
	[D_VOID, D_VOID, D_VOID],
]

const WALL_NORTH = [
	[D_VOID, D_VOID, D_VOID],
	[D_VOID, D_WALL, D_VOID],
	[D_VOID, D_FLOOR, D_VOID],
]

const WALL_SOUTH = [
	[D_VOID, D_FLOOR, D_VOID],
	[D_VOID, D_WALL, D_VOID],
	[D_VOID, D_VOID, D_VOID],
]

const WALL_CORNER_NW = [
	[D_VOID, D_VOID, D_VOID],
	[D_VOID, D_CORNER, D_WALL],
	[D_VOID, D_WALL, D_FLOOR],
]

const WALL_CORNER_NE = [
	[D_VOID, D_VOID, D_VOID],
	[D_WALL, D_CORNER, D_VOID],
	[D_FLOOR, D_WALL, D_VOID],
]

const WALL_CORNER_SW = [
	[D_VOID, D_WALL, D_FLOOR],
	[D_VOID, D_CORNER, D_WALL],
	[D_VOID, D_VOID, D_VOID],
]

const WALL_CORNER_SE = [
	[D_FLOOR, D_WALL, D_VOID],
	[D_WALL, D_CORNER, D_VOID],
	[D_VOID, D_VOID, D_VOID],
]

const WALL_ANGLE_NW = [
	[D_VOID, D_VOID, D_VOID],
	[D_VOID, D_WALL, D_FLOOR],
	[D_VOID, D_FLOOR, D_FLOOR],
]

const WALL_ANGLE_SW = [
	[D_VOID, D_FLOOR, D_FLOOR],
	[D_VOID, D_WALL, D_FLOOR],
	[D_VOID, D_VOID, D_VOID],
]

const WALL_ANGLE_NE = [
	[D_VOID, D_VOID, D_VOID],
	[D_FLOOR, D_WALL, D_VOID],
	[D_FLOOR, D_FLOOR, D_VOID],
]

const WALL_ANGLE_SE = [
	[D_FLOOR, D_FLOOR, D_VOID],
	[D_FLOOR, D_WALL, D_VOID],
	[D_VOID, D_VOID, D_VOID],
]

const WALL_COLUMN = [
	[D_FLOOR, D_FLOOR, D_FLOOR],
	[D_FLOOR, D_WALL, D_FLOOR],
	[D_FLOOR, D_FLOOR, D_FLOOR],
]

const WALL_INNER_WSE = [
	[D_VOID, D_VOID, D_VOID],
	[D_FLOOR, D_WALL, D_FLOOR],
	[D_VOID, D_FLOOR, D_VOID],
]

const WALL_INNER_WNE = [
	[D_VOID, D_FLOOR, D_VOID],
	[D_FLOOR, D_WALL, D_FLOOR],
	[D_VOID, D_VOID, D_VOID],
]

const WALL_INNER_NWS = [
	[D_VOID, D_FLOOR, D_VOID],
	[D_VOID, D_WALL, D_FLOOR],
	[D_VOID, D_FLOOR, D_VOID],
]

const WALL_INNER_SEN = [
	[D_VOID, D_FLOOR, D_VOID],
	[D_FLOOR, D_WALL, D_VOID],
	[D_VOID, D_FLOOR, D_VOID],
]

const WALL_INNER_NS = [
	[D_VOID, D_FLOOR, D_VOID],
	[D_VOID, D_WALL, D_VOID],
	[D_VOID, D_FLOOR, D_VOID],
]

const WALL_INNER_WE = [
	[D_VOID, D_VOID, D_VOID],
	[D_FLOOR, D_WALL, D_FLOOR],
	[D_VOID, D_VOID, D_VOID],
]

const DIRT_IDX  = 0
const DIRT_NUM  = 5
const FLOOR_IDX = 1
const FLOOR_NUM = 6
const WALL_IDX  = 2
const WALL_NUM  = 5
const DOORH_IDX = 3
const DOORH_NUM = 1
const DOORV_IDX = 4
const DOORV_NUM = 1
const WALL_NORTH_IDX = 7
const WALL_NORTH_NUM = 1
const WALL_EAST_IDX  = 8
const WALL_EAST_NUM  = 1
const WALL_SOUTH_IDX = 5
const WALL_SOUTH_NUM = 1
const WALL_WEST_IDX  = 6
const WALL_WEST_NUM  = 1
const WALL_CORNER_NW_IDX = 20
const WALL_CORNER_NW_NUM = 1
const WALL_CORNER_NE_IDX = 21
const WALL_CORNER_NE_NUM = 1
const WALL_CORNER_SW_IDX = 19
const WALL_CORNER_SW_NUM = 1
const WALL_CORNER_SE_IDX = 22
const WALL_CORNER_SE_NUM = 1
const WALL_ANGLE_NW_IDX = 10
const WALL_ANGLE_NW_NUM = 1
const WALL_ANGLE_SW_IDX = 9
const WALL_ANGLE_SW_NUM = 1
const WALL_ANGLE_NE_IDX = 11
const WALL_ANGLE_NE_NUM = 1
const WALL_ANGLE_SE_IDX = 12
const WALL_ANGLE_SE_NUM = 1
const WALL_COLUMN_IDX = 2
const WALL_COLUMN_NUM = 5
const WALL_INNER_NS_IDX = 13
const WALL_INNER_NS_NUM = 1
const WALL_INNER_WE_IDX = 14
const WALL_INNER_WE_NUM = 1
const WALL_INNER_WNE_IDX = 18
const WALL_INNER_WNE_NUM = 1
const WALL_INNER_WSE_IDX = 16
const WALL_INNER_WSE_NUM = 1
const WALL_INNER_NWS_IDX = 15
const WALL_INNER_NWS_NUM = 1
const WALL_INNER_SEN_IDX = 17
const WALL_INNER_SEN_NUM = 1

var wall_features = []

class WallFeature:
	var _idx
	var _num
	var _feature
	
	func _init(feature, idx, num):
		_idx = idx  # Tile column index
		_num = num  # Num of tiles
		_feature = feature  # Feature map
		
	func compare(tiles, x, y):
		var i = 0
		while i < 3:
			var j = 0
			while j < 3:
				if _feature[j][i] != D_VOID and _feature[j][i] != tiles[y+j][x+i]:
					if (tiles[y+j][x+i] == D_DOORH || tiles[y+j][x+i] == D_DOORV) and _feature[j][i] == D_FLOOR:
						pass
					else:
						return false
				j += 1
			i += 1
		return true


func init_room_features():
	# Order is important: the more specific feature must be inserted first,
	# and the less specific ones (with more void cells) at the end
	wall_features.append(WallFeature.new(WALL_COLUMN,    WALL_COLUMN_IDX,    WALL_COLUMN_NUM))
	wall_features.append(WallFeature.new(WALL_INNER_WNE, WALL_INNER_WNE_IDX, WALL_INNER_WNE_NUM))
	wall_features.append(WallFeature.new(WALL_INNER_WSE, WALL_INNER_WSE_IDX, WALL_INNER_WSE_NUM))
	wall_features.append(WallFeature.new(WALL_INNER_NWS, WALL_INNER_NWS_IDX, WALL_INNER_NWS_NUM))
	wall_features.append(WallFeature.new(WALL_INNER_SEN, WALL_INNER_SEN_IDX, WALL_INNER_SEN_NUM))
	wall_features.append(WallFeature.new(WALL_INNER_NS,  WALL_INNER_NS_IDX,  WALL_INNER_NS_NUM))
	wall_features.append(WallFeature.new(WALL_INNER_WE,  WALL_INNER_WE_IDX,  WALL_INNER_WE_NUM))
	wall_features.append(WallFeature.new(WALL_CORNER_NW, WALL_CORNER_NW_IDX, WALL_CORNER_NW_NUM))
	wall_features.append(WallFeature.new(WALL_CORNER_NE, WALL_CORNER_NE_IDX, WALL_CORNER_NE_NUM))
	wall_features.append(WallFeature.new(WALL_CORNER_SW, WALL_CORNER_SW_IDX, WALL_CORNER_SW_NUM))
	wall_features.append(WallFeature.new(WALL_CORNER_SE, WALL_CORNER_SE_IDX, WALL_CORNER_SE_NUM))
	wall_features.append(WallFeature.new(WALL_ANGLE_NW,  WALL_ANGLE_NW_IDX,  WALL_ANGLE_NW_NUM))
	wall_features.append(WallFeature.new(WALL_ANGLE_NE,  WALL_ANGLE_NE_IDX,  WALL_ANGLE_NE_NUM))
	wall_features.append(WallFeature.new(WALL_ANGLE_SW,  WALL_ANGLE_SW_IDX,  WALL_ANGLE_SW_NUM))
	wall_features.append(WallFeature.new(WALL_ANGLE_SE,  WALL_ANGLE_SE_IDX,  WALL_ANGLE_SE_NUM))
	wall_features.append(WallFeature.new(WALL_WEST,      WALL_WEST_IDX,      WALL_WEST_NUM))
	wall_features.append(WallFeature.new(WALL_EAST,      WALL_EAST_IDX,      WALL_EAST_NUM))
	wall_features.append(WallFeature.new(WALL_NORTH,     WALL_NORTH_IDX,     WALL_NORTH_NUM))
	wall_features.append(WallFeature.new(WALL_SOUTH,     WALL_SOUTH_IDX,     WALL_SOUTH_NUM))
	wall_features.append(WallFeature.new(WALL_SOUTH,     WALL_SOUTH_IDX,     WALL_SOUTH_NUM))
	wall_features.append(WallFeature.new(WALL_DEFAULT,   WALL_IDX,           WALL_NUM))


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
	$SeedEdit.text = "0"
	$RoomEdit.text = "8"
	init_room_features()
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
		$SeedEdit.text = str(dungeon_seed)
		# Generate dungeon
		generate_dungeon_3(dungeon_seed, $RoomEdit.text.to_int())
		return


func _on_SeedEdit_text_entered(new_text):
	generate_dungeon_3(new_text.to_int(), $RoomEdit.text.to_int())
	$SeedEdit.release_focus()


func _on_RoomEdit_text_entered(new_text):
	generate_dungeon_3($SeedEdit.text.to_int(), new_text.to_int())
	$RoomEdit.release_focus()


func draw_tilemap(room, ox, oy):
	var tiles = room.get_tiles()
	var tilemap = $TileMap
	var tile = Vector2i(0, 0) # tile coords
	var shadow = false
	var shadow_tile = Vector2i(0, 0) # shadow tile coords
	for y in range(room.get_size()):
		for x in range(room.get_size()):
			shadow = false
			if tiles[y][x] == D_FLOOR:
				tile.x = FLOOR_IDX
				tile.y = randi() % FLOOR_NUM
			elif tiles[y][x] == D_WALL or tiles[y][x] == D_CORNER:
				for f in wall_features:
					if f.compare(tiles, x-1, y-1):
						tile.x = f._idx
						tile.y = randi() % f._num
						break
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
			if shadow:
				tilemap.set_cell(1, pos, 0, tile)


func generate_dungeon():
	var tilemap = $TileMap
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
		l = randi() % (ry - 1)
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
		l = randi() % (ah - y - 1)
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
		l = randi() % (aw - x - 1)
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
		l = randi() % (rx - 1)
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
		var x = min(2 + randi() % (D_WIDTH-2), D_HEIGHT-8-2)
		var y = min(2 + randi() % (D_WIDTH-2), D_HEIGHT-8-2)
		var width = 2 + randi() % 6
		var height = 2 + randi() % 6
		print(x, '/', y, '/', width, '/', height)
		fill_box(dungeon, x, y, width, height, D_FLOOR)
		dig_corridors(dungeon, D_WIDTH, D_HEIGHT, x, y, width, height)
	draw_walls(dungeon, D_WIDTH, D_HEIGHT)
	var room = Room.new(dungeon)
	draw_tilemap(room, 0, 0)
