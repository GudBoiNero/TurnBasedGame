extends Area2D
class_name Tile

var tex: Texture = preload("res://resources/tiles/wood_platform/wood_platform.png")
var sprite: Sprite = Sprite.new()

func _ready():
	self.z_index = -1
	sprite.position.y = 8
	add_child(sprite)
	sprite.texture = tex
