extends Spatial

var tiles
var tiles1
var tiles2


func _onready():
	tiles = preload("res://tiles.tscn")
	tiles1 = tiles.instance()
	tiles2 = tiles.instance()
	
	var tiles1_lane_str = tiles1.get_node("lane_str").duplicate()
	
	tiles1_lane_str.set_position(Vector3.ZERO)
	add_child(tiles1_lane_str)

