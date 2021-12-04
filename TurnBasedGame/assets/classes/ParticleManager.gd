extends Node2D
class_name ParticleManager

var one_shot: bool = true
var num_particles: int = 1
var time: float
var particle: int = 100
var tex: Texture =  Game.registered_particles.get(particle)[1]
var instanced_particles = Game.registered_particles.get(particle)[0]

# Animation Related
var animated: bool
var anim_speed: int = 1

var blend_mode: int
var light_mode: int
var h_frames: int
var v_frames: int
var particles_anim_loop: bool
var render_prio: int

var part = Particles2D.new()

func _ready():
	part.one_shot = true
	part.amount = num_particles
	
	part.process_material = instanced_particles
	part.process_material.anim_speed = anim_speed
	part.texture = tex
	
	if animated: # Reassigns all given values to make it animateable
		# Canvas Item Properties
		part.material = CanvasItemMaterial.new()
		var m = part.material
		m.particles_animation = animated
		m.blend_mode = blend_mode
		m.light_mode = light_mode
		m.particles_anim_h_frames = h_frames
		m.particles_anim_v_frames = v_frames
		m.particles_anim_loop = particles_anim_loop
	
	add_child(part)
	yield(get_tree().create_timer(time),"timeout")
	queue_free()
