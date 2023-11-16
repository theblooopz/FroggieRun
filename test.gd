extends Spatial

var tiles
var tiles1
var tiles2

var all_tiles
var ticker = 0


func _ready():
	tiles = preload("res://tiles.tscn")
	tiles1 = tiles.instance()
	
	all_tiles = Spatial.new()
	
	var tiles1_lane_str = tiles1.get_node("lane_str").duplicate()
	var tiles1_lane_str2 = tiles1.get_node("lane_str2").duplicate()
	var tiles1_lane_str3 = tiles1.get_node("lane_str3").duplicate()
	
	tiles1_lane_str.set_translation(Vector3.ZERO)
	tiles1_lane_str2.set_translation(Vector3(-8,0,0))
	tiles1_lane_str3.set_translation(Vector3(-16,0,0))
	all_tiles.add_child(tiles1_lane_str)
	all_tiles.add_child(tiles1_lane_str2)
	all_tiles.add_child(tiles1_lane_str3)

	add_child(all_tiles)

func _process(delta):
	if Globals.playing:
		ticker += 1
		all_tiles.set_translation(Vector3(0,0,ticker))


func _on_trail_repeat_body_entered(body):
	if body.is_in_group("TILE"):
		print("TILE")
		ticker = 0
