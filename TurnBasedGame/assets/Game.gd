extends Node2D

signal turn_executed

var player_pos: Vector2

var global_z_indexes = [
	-2, # Pillars
	-1, # Tiles
	0, # Objects
	1, 
	2,
	3,
	4,
	5
]

var tile_size = 16
var tile_grid = {
	Vector2(0+10,0+10): Tile.new(),
	Vector2(0+10,1+10): Tile.new(),
	Vector2(0+10,2+10): Tile.new(),
	Vector2(-1+10,2+10): Tile.new(),
	Vector2(-2+10,2+10): Tile.new(),
	Vector2(-3+10,0+10): Tile.new(),
	Vector2(-1+10,0+10): Tile.new(),
	Vector2(-2+10,1+10): Tile.new(),
	Vector2(-2+10,0+10): Tile.new(),
	Vector2(1+10,1+10): Tile.new(),
	Vector2(2+10,1+10): Tile.new(), 
	Vector2(-3+10,-1+10): Tile.new(),
	Vector2(-3+10,-2+10): Tile.new(),
	Vector2(-2+10,-2+10): Tile.new(),
	Vector2(-1+10,-2+10): Tile.new(),
	Vector2(-1+10,-1+10): Tile.new(),
	Vector2(-4+10,-1+10): Tile.new(),
	Vector2(-4+10,-2+10): Tile.new(),
	Vector2(-4+10,0+10): Tile.new(),
	Vector2(-5+10,0+10): Tile.new(),
	Vector2(-5+10,-1+10): Tile.new(),
	Vector2(-5+10,-2+10): Tile.new(),
	Vector2(-5+10,-3+10): Tile.new(),
}

var entity_grid = {
	Vector2(0+10,0+10): preload("res://assets/Player.tscn").instance(),
	Vector2(-2+10,0+10): Entity.new()
}

var obj_grid = {
	Vector2(0+10,0+10): Pot.new(),
	Vector2(-3+10,0+10): Pot.new()
}

# Each Entity/Object gets it's own assigned first value. The players is 1 so it can have 100 entries in this dict 100 particles 
# 101, 102, 103... ...197, 198, 199, and 200 are all of the entries it is able to store its particles in.
var registered_particles = {
	100: [
		preload("res://resources/particles/player_move_particles/PlayerMoveParticles.tres"),
		preload("res://resources/particles/player_move_particles/player_move_particles-Sheet.png")
	]
}

func player_turn_executed():
	emit_signal("turn_executed")

func get_next(dir:Vector2, type:int, pos:Vector2):
	var p = pos+dir
	match type:
		0:
			if entity_grid.has(p):
				return entity_grid.get(p) is Entity
		1:
			if obj_grid.has(p):
				return not(obj_grid.get(p) is InteractableObj) and (obj_grid.get(p) is Obj)
		2:
			if tile_grid.has(p):
				return tile_grid.get(p) is Tile

func _physics_process(delta):
	for e in entity_grid.keys():
		for o in obj_grid.keys():
			if obj_grid.has(e) and entity_grid.has(o):
				match get_priority(entity_grid.get(e).prio,obj_grid.get(o).prio):
					0:
						obj_grid.get(o).queue_free()
						obj_grid.erase(o)
						
						entity_grid.get(e).queue_free()
						entity_grid.erase(e)
					1:
						if obj_grid.get(o).has_method("destroy"):
							obj_grid.get(o).destroy()
						else:
							obj_grid.get(o).queue_free()
						obj_grid.erase(o)
					2:
						entity_grid.get(e).queue_free()
						entity_grid.erase(e)

func get_priority(one,two):
	if one > two:
		return 1
	elif two > one:
		return 2
	else:
		return 0

# Random Things For Testing or Screwing Around

func rand_vec2():
	var a = RandomNumberGenerator.new()
	a.randomize()
	var axis = a.randi_range(0,1)
	if axis == 0: # X
		var d = RandomNumberGenerator.new()
		d.randomize()
		if d.randi_range(0,1) == 0:
			return Vector2(1,0)
		else:
			return Vector2(-1,0)
	else: # Y
		var d = RandomNumberGenerator.new()
		d.randomize()
		if d.randi_range(0,1) == 0:
			return Vector2(0,1)
		else:
			return Vector2(0,-1)

func rand_bool():
	var a = RandomNumberGenerator.new()
	a.randomize()
	var axis = a.randi_range(0,1)
	if axis == 0:
		return false
	else: return true
