extends Node2D

const D_WIDTH  = 20
const D_HEIGHT = 15

const D_ANYSIDE = 0
const D_NORTH   = 1
const D_EAST    = 2
const D_SOUTH   = 3
const D_WEST    = 4

const D_FLOOR = 0
const D_WALL  = 1
const D_DIRT  = 2

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

var DIRT_IDX = 0
var DIRT_NUM = 1
var FLOOR_IDX = DIRT_IDX + DIRT_NUM
var FLOOR_NUM = 5
var WALL_IDX = FLOOR_IDX + FLOOR_NUM
var WALL_NUM = 2

class Room:
    var _size = 0 setget , get_size
    var _tiles = [] setget set_tiles, get_tiles
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
        var x
        var y
        # North
        y = 1
        for x in range(1, _size-1):
            if _tiles[y][x] == 0:
                portals[D_NORTH].append([x,y])
        # South
        y = _size - 2
        for x in range(1, _size-1):
            if _tiles[y][x] == 0:
                portals[D_SOUTH].append([x,y])
        x = 1
        # East
        for y in range(1, _size-1):
            if _tiles[y][x] == 0:
                portals[D_EAST].append([x,y])
        x = _size - 2
        # West
        for y in range(1, _size-1):
            if _tiles[y][x] == 0:
                portals[D_WEST].append([x,y])
        # Set portals
        _portals = portals

    func get_portals():
        # Return a deep copy of _portals
        return str2var( var2str( _portals ) )

func _ready():
    set_process_input(true)
    generate_dungeon_3()
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
        generate_dungeon_3()
        return

func draw_room(room, ox, oy):
    var tiles = room.get_tiles()
    var tilemap = get_node("TileMap")
    var id
    for y in range(room.get_size()):
        for x in range(room.get_size()):
            if tiles[y][x] == D_FLOOR:
                id =  FLOOR_IDX + randi() % FLOOR_NUM
            elif tiles[y][x] == D_WALL:
                id = WALL_IDX + randi() % WALL_NUM
            else:
                id = DIRT_IDX + randi() % DIRT_NUM
            tilemap.set_cell(ox + x, oy + y, id)

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
            draw_room(rooms[id], x * 5, y * 5)
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

func fill_box(a, x, y, w, h):
    for i in range(y, y+h):
        for j in range(x, x+w):
            a[i][j] = D_FLOOR

func draw_walls(a, w, h):
    var prev = -1
    for y in range(h):
        for x in range(w):
            if a[y][x] == D_FLOOR and prev == D_DIRT:
                a[y][x-1] = D_WALL
            elif a[y][x] == D_DIRT and prev == D_FLOOR:
                a[y][x] = D_WALL
            prev = a[y][x]
    prev = -1
    for x in range(w):
        for y in range(h):
            if a[y][x] == D_FLOOR and prev == D_DIRT:
                a[y-1][x] = D_WALL
            elif a[y][x] == D_DIRT and prev == D_FLOOR:
                a[y][x] = D_WALL
            prev = a[y][x]

func generate_dungeon_3():
    var dungeon = alloc_array(20, 20)
    var room_num = 10
    for idx in range(room_num):
        var x = min(1 + randi() % (20-1), 20-6-1)
        var y = min(1 + randi() % (20-1), 20-6-1)
        var width = 2 + randi() % 4
        var height = 2 + randi() % 4
        print(x, '/', y, '/', width, '/', height)
        fill_box(dungeon, x, y, width, height)
    draw_walls(dungeon, 20, 20)
    var room = Room.new(dungeon)
    draw_room(room, 0, 0)

