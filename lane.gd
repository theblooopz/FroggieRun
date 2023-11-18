extends Spatial

var coin = preload("res://assets/coin/coin.tscn").instance()
var crate = preload("res://assets/objects/crate/crate.tscn").instance()
var wall = preload("res://assets/objects/wall.tscn").instance()
var slope = preload("res://assets/objects/slope/slope.tscn").instance()
var block = preload("res://assets/objects/block/block.tscn").instance()


func spawn():
	
	for child in $spawns.get_children():
		
		
		var obj = null
		var offset = 0
		
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
			if chance <= 1:
				obj = slope.duplicate()
				offset = 0
		
		if not obj:
			chance = rand_range(0,10)
			if chance <= 1:
				obj = block.duplicate()
				offset = 0
		
		if not obj:
			chance = rand_range(0,10)
			if chance <= 0.5:
				obj = wall.duplicate()
				offset = 0
		
		if obj:
			obj.set_translation(Vector3(0,offset,0))
			child.add_child(obj)
			
