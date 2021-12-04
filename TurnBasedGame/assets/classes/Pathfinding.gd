extends Node2D
class_name Pathfinding

var astar = AStar2D.new()
var grid: Dictionary
var path: PoolVector2Array

var from: Vector2
var to: Vector2
# Called when the node enters the scene tree for the first time.
func _ready():
	grid = Game.tile_grid
	_add_points()
	_connect_points()

func _add_points():
	for p in grid.keys():
		astar.add_point(id(p),p,1.0)

func _connect_points():
	for p in grid.keys():
		var neighbors = [Vector2.UP,Vector2.RIGHT,Vector2.DOWN,Vector2.LEFT]
		for n in neighbors:
			if is_valid_position(n,p):
				astar.connect_points(id(p),id(n+p),false)

func id(point):
	var a = point.x
	var b = point.y
	return (a + b) * (a + b + 1) / 2 + b

func return_path() -> Vector2:
	var path = astar.get_point_path(id(from),id(to))
	path.remove(0)
	print(path)
	return Vector2(0,0)

func is_valid_position(dir,pos) -> bool:
	if !Game.get_next(dir,0,pos) and !Game.get_next(dir,1,pos) and Game.get_next(dir,2,pos):
		return true
	else:
		return false
