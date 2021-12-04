extends Node

var ex_array = [] # Array
var ex_dict = {
	Vector2(0,0): "This is 0,0 in the grid"
} # Dictionary

func _ready():
	pass


func _get_array(array, number):
	return array[number-1]
