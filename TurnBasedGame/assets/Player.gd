extends Entity
class_name Player

onready var p_anim = $PlayerAnim
onready var p_sprite = $Sprite

var moveable: bool = true
var p_facing: Vector2

var inputs = {
	"mov_right": Vector2.RIGHT,
	"mov_left": Vector2.LEFT,
	"mov_up": Vector2.UP,
	"mov_down": Vector2.DOWN
}

func _ready():
	prio = 3

func _physics_process(delta):
	Game.player_pos = grid_pos

func _unhandled_input(event):
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			if moveable:
				match dir:
					"mov_up":
						move(Vector2.UP, 1, false)
					"mov_right":
						move(Vector2.RIGHT, 1, false)
					"mov_down":
						move(Vector2.DOWN, 1, false)
					"mov_left":
						move(Vector2.LEFT, 1, false)

func move(dir, length, tp):
	if can_move(dir):
		var p = ParticleManager.new()
		p.time = 0.8
		p.particle = 100
		p.h_frames = 7
		p.v_frames = 1
		p.animated = true
		p.anim_speed = 3
		p.position = grid_pos * Game.tile_size
		p.position.y += -8
		p.num_particles = 1
		p.one_shot = true
		p.particles_anim_loop = false
		get_parent().add_child(p)
		tweak_grid(dir,length)
		moveable = false
		tween_movement(dir*Vector2(length,length),tp)
		set_animations(dir, true)
		position += dir * tile_size
		
		Game.player_turn_executed()
	else:
		set_animations(dir, false)

func tween_movement(dir,tp):
	if !tp:
		tween.interpolate_property(
			self,"position",
			position,position + dir * Vector2(tile_size,tile_size),
			0.05,
			Tween.TRANS_LINEAR, Tween.EASE_IN)
		tween.start()
	yield(get_tree().create_timer(0.2),"timeout")
	moveable = true

func tweak_grid(vec, length):
	Game.entity_grid[grid_pos+vec] = Game.entity_grid[grid_pos]
	Game.entity_grid.erase(grid_pos)
	grid_pos += vec

func set_animations(dir, state):
	if state:
		match dir:
			Vector2.UP:
				p_anim.play("IdleUp")
				p_facing = dir
			Vector2.RIGHT:
				p_anim.play("IdleHorizontal")
				p_sprite.scale.x = -1
				p_facing = dir
			Vector2.DOWN:
				p_anim.play("IdleDown")
				p_facing = dir
			Vector2.LEFT:
				p_anim.play("IdleHorizontal")
				p_sprite.scale.x = 1
				p_facing = dir
	else:
		match dir:
			Vector2.UP:
				p_anim.play("FailUp")
				p_facing = dir
			Vector2.RIGHT:
				p_anim.play("FailHorizontal")
				p_sprite.scale.x = -1
				p_facing = dir
			Vector2.DOWN:
				p_anim.play("FailDown")
				p_facing = dir
			Vector2.LEFT:
				p_anim.play("FailHorizontal")
				p_sprite.scale.x = 1
				p_facing = dir


func _on_PlayerAnim_animation_finished(anim_name):
	match p_facing:
		Vector2.UP:
			p_anim.play("IdleUp")
		Vector2.RIGHT:
			p_anim.play("IdleHorizontal")
			p_sprite.scale.x = -1
		Vector2.DOWN:
			p_anim.play("IdleDown")
		Vector2.LEFT:
			p_anim.play("IdleHorizontal")
			p_sprite.scale.x = 1

func _get_tex() -> Texture:
	return null # Because the players sprite is already set in the editor

func turn_ex():
	pass
