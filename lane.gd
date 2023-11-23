extends Spatial

var coin = preload("res://assets/coin/coin.tscn").instance()
var crate = preload("res://assets/objects/crate/crate.tscn").instance()
var wall = preload("res://assets/objects/wall.tscn").instance()
var slope = preload("res://assets/objects/slope/slope.tscn").instance()
var block = preload("res://assets/objects/block.tscn").instance()
var ray


func _ready():
	ray = $ray
	remove_child(ray)

func spawn():
	
	for child in $spawns.get_children():
		
		if child.get_children():
			continue
		
		var obj = null
		var offset = 0
		var left_obj
		var right_obj
		
		if is_in_group("CENTER_TILE"):
			child.add_child(ray)
			
			ray.set_cast_to(Vector3(12,1,0))
			if ray.is_colliding():
				left_obj = ray.get_collision_object()
			ray.set_cast_to(Vector3(-12,1,0))
			if ray.is_colliding():
				right_obj = ray.get_collision_object()
			
			child.remove_child(ray)
			
			if left_obj and right_obj:
				
				if left_obj.is_in_group("WALL") and\
				right_obj.is_in_group("WALL"):
					continue
			
				if left_obj.is_in_group("BLOCK") and\
				right_obj.is_in_group("BLOCK"):
					continue
		
		
		var chance = rand_range(0,10)
		if chance <= 2:
			obj = coin.duplicate()
			offset  = 1
			
		if not obj:
			chance = rand_range(0,10)
			if chance <= 0.5:
				obj = crate.duplicate()
				offset = 0
		
		if not obj:
			chance = rand_range(0,10)
			if chance <= 0.33:
				obj = slope.duplicate()
				offset = 0
		
		if not obj:
			chance = rand_range(0,10)
			if chance <= 1:
				obj = block.duplicate()
				offset = 2
		
		if not obj:
			chance = rand_range(0,10)
			if chance <= 0.5:
				obj = wall.duplicate()
				offset = 5
		
		if obj:
			obj.set_translation(Vector3(0,offset,0))
			child.add_child(obj)
			
