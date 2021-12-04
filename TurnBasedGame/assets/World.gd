extends Node2D

var tile_grid = Game.tile_grid
var entity_grid = Game.entity_grid
var obj_grid = Game.obj_grid

func _ready():
	for i in tile_grid.keys():
		tile_grid.get(i).position = Vector2(Game.tile_size, Game.tile_size) * i
		$Tiles.add_child(tile_grid.get(i))
	
	for i in entity_grid.keys():
		entity_grid.get(i).position = Vector2(Game.tile_size, Game.tile_size) * i
		entity_grid.get(i).grid_pos = i
		$Entities.add_child(entity_grid.get(i))
	
	for i in obj_grid.keys():
		obj_grid.get(i).position = Vector2(Game.tile_size, Game.tile_size) * i
		$Objects.add_child(obj_grid.get(i))
