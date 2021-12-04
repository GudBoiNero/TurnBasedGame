extends Area2D
class_name Obj

var prio = 1

# Collision
onready var col = CollisionShape2D.new()
var collideable: bool = true

# Sprite
var tex: Texture = _get_tex()
var sprite: Sprite = Sprite.new()

func _ready():
	sprite.z_index = Game.global_z_indexes[3]
	sprite.texture = tex
	sprite.position.y = -8
	
	col.shape = RectangleShape2D.new()
	col.shape.extents = Vector2(8,8)
	col.z_index = 1
	add_child(sprite)
	add_child(col)

func _get_tex() -> Texture:
	return preload("res://resources/objects/null_object.png")
