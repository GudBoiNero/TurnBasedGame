extends Area2D
class_name Entity

var prio = 2
var facing: Vector2

# Animation
var anim = AnimationPlayer.new()
var animations = [
	"IdleUp",
	"IdleDown",
	"IdleHorizontal"
]

var tex: Texture = preload("res://resources/entities/bad_cube/bad_cube-Sheet.png")
var sprite = Sprite.new()
var col = CollisionShape2D.new()
var tween = Tween.new()
var pathfinding = Pathfinding.new()

# Grid Related
var tile_size
var dir: Vector2 = Vector2(0,0)
var grid_pos: Vector2

# Raycasts
var rays = Node2D.new()
var u = RayCast2D.new()
var r = RayCast2D.new()
var d = RayCast2D.new()
var l = RayCast2D.new()

func _ready():
	# Animation Setup
#	add_child(anim)
#	var idle_up = Animation.new()
#	var idle_down = Animation.new()
#	var idle_horizontal = Animation.new()
#
#	idle_up.add_track(0)
#	idle_up.track_set_path(0, "sprite:frame")
#	idle_up.track_insert_key(0,0,0)
#	idle_up.track_insert_key(0,1,1)
#	idle_up.track_insert_key(0,2,2)
#	idle_up.track_insert_key(0,3,3)
#	idle_up.track_insert_key(0,3.5,0)
#	idle_up.loop = true
#
#	idle_down.add_track(0)
#	idle_down.track_set_path(0, "sprite:frame")
#	idle_down.track_insert_key(0,0,0)
#	idle_down.track_insert_key(0,1,1)
#	idle_down.track_insert_key(0,2,2)
#	idle_down.track_insert_key(0,3,3)
#	idle_down.track_insert_key(0,3.5,0)
#	idle_down.loop = true
#
#	idle_horizontal.add_track(0)
#	idle_horizontal.track_set_path(0, "sprite:frame")
#	idle_horizontal.track_insert_key(0,0,0)
#	idle_horizontal.track_insert_key(0,1,1)
#	idle_horizontal.track_insert_key(0,2,2)
#	idle_horizontal.track_insert_key(0,3,3)
#	idle_horizontal.track_insert_key(0,3.5,0)
#	idle_horizontal.loop = true
#
#	anim.add_animation(animations[0], idle_up)
#	anim.add_animation(animations[1], idle_down)
#	anim.add_animation(animations[2], idle_horizontal)
	
	# Sprite Setup
	sprite.texture = _get_tex()
	sprite.hframes = 12
	sprite.position.y += -8
	add_child(sprite)
	tile_size= Game.tile_size
	_init_nodes()
	
	Game.connect(
		"turn_executed", # Global ignal
		self, # Reference to self
		"turn_ex" # Function inside `Entity.gd` to call on signal emitted
	)

func turn_ex():
	move(determine_dir(), 1, false)

func move(dir, length, tp):
	if can_move(dir):
		tweak_grid(dir,length)
		tween_movement(dir*Vector2(length,length),tp)
		set_animations(dir, true)
		position += dir * tile_size
	else:
		if is_stuck():
			pass

func can_move(vec:Vector2) -> bool:
	if Game.tile_grid.has(grid_pos+vec) and !Game.entity_grid.has(grid_pos+vec):
		if !Game.obj_grid.get(grid_pos+vec) is Obj:
			return true
		elif !Game.obj_grid.get(grid_pos+vec) is InteractableObj:
			return false
		else:
			return true
	else:
		return false

func tween_movement(dir:Vector2,tp:bool):
	if !tp:
		tween.interpolate_property(
			self,"position",
			position,position + dir * Vector2(tile_size,tile_size),
			0.05,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()

func determine_dir():
	var path = Pathfinding.new()
	path.from = grid_pos
	path.to = Game.player_pos
	add_child(path)
	
	return path.return_path()
	path.queue_free()

func _init_nodes():
	col.shape = RectangleShape2D.new()
	col.shape.extents = Vector2(6,6)
	add_child(col)
	add_child(tween)
	add_child(rays)
	u.cast_to=Vector2(0,-8)
	r.cast_to=Vector2(8,0)
	d.cast_to=Vector2(0,8)
	l.cast_to=Vector2(-8,0)
	u.enabled = true
	r.enabled = true
	d.enabled = true
	l.enabled = true
	rays.add_child(u)
	rays.add_child(r)
	rays.add_child(d)
	rays.add_child(l)

func tweak_grid(vec:Vector2, length):
	Game.entity_grid[grid_pos+vec] = Game.entity_grid[grid_pos]
	Game.entity_grid.erase(grid_pos)
	grid_pos += vec

func set_animations(dir:Vector2, state:bool):
	if state:
		# todo animations
		match dir:
			Vector2.UP:
				#anim.play("IdleUp")
				facing = dir
			Vector2.RIGHT:
				#anim.play("IdleHorizontal")
				sprite.scale.x = -1
				facing = dir
			Vector2.DOWN:
				#anim.play("IdleDown")
				facing = dir
			Vector2.LEFT:
				#anim.play("IdleHorizontal")
				sprite.scale.x = 1
				facing = dir

func is_stuck() -> bool:
#	if Game.get_next(Vector2.UP, 0, grid_pos) and Game.get_next(Vector2.RIGHT, 0, grid_pos) and Game.get_next(Vector2.DOWN, 0, grid_pos) and Game.get_next(Vector2.LEFT, 0, grid_pos):
	if Game.get_next(Vector2.UP, 0,grid_pos) or Game.get_next(Vector2.UP, 1,grid_pos) or !Game.get_next(Vector2.UP, 2,grid_pos):
		if Game.get_next(Vector2.RIGHT, 0,grid_pos) or Game.get_next(Vector2.RIGHT, 1,grid_pos) or !Game.get_next(Vector2.RIGHT, 2,grid_pos):
			if Game.get_next(Vector2.DOWN, 0,grid_pos) or Game.get_next(Vector2.DOWN, 1,grid_pos) or !Game.get_next(Vector2.DOWN, 2,grid_pos):
				if Game.get_next(Vector2.LEFT, 0,grid_pos) or Game.get_next(Vector2.LEFT, 1,grid_pos) or !Game.get_next(Vector2.LEFT, 2,grid_pos):
					return true
				return false
			return false
		return false
	else: return false

func _get_tex() -> Texture:
	return preload("res://resources/entities/bad_cube/bad_cube-Sheet.png")
