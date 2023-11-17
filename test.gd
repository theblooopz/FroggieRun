extends Spatial

var ticker = 0

func _process(delta):
	if Globals.playing:
		ticker += 0.5
		if ticker > 999999:
			ticker = 0
		$tiles.set_translation(Vector3(0,0,ticker))


func _on_trail_repeat_body_entered(body):
	
	if body.is_in_group("TILE"):
		var p = body.get_parent()
		var t = p.get_translation()
		
		var arr = [0,8,8*2]
		t.z -= 128*2 + arr[randi()%3]
		p.set_translation(t)
		p.call_deferred("spawn")


func _on_trail_destroy_body_entered(body):
	if body.is_in_group("DESTROY"):
		body.queue_free()


func _on_trail_destroy_area_entered(area):
	if area.is_in_group("DESTROY"):
		area.queue_free()


func _on_container_body_exited(body):
	if not body.is_in_group("PLAYER"):
		body.queue_free()
