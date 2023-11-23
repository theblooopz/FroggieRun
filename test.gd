extends Spatial

var ticker = 0
var tile_passes = 0

func _process(delta):
	if Globals.playing:
		ticker += 0.66
		$tiles.set_translation(Vector3(0,0,ticker))


func _on_trail_repeat_body_entered(body):
	
	if body.is_in_group("TILE") and not body.is_in_group("CENTER_TILE"):
		var p = body.get_parent()
		var t = p.get_translation()
		
		var arr = [0,8,8*1.75]
		#var arr2 = [0,4,4*2]
		t.z -= 128*2 #+ arr[randi()%3]
		#t.y -= arr2[randi()%3]
		p.set_translation(t)
		p.call_deferred("spawn")
		tile_passes += 1
	
	if body.is_in_group("CENTER_TILE") and tile_passes >= 2:
		var p = body.get_parent()
		var t = p.get_translation()

		var arr = [0,8,8*1.75]
		#var arr2 = [0,4,4*2]
		t.z -= 128*2 #+ arr[randi()%3]
		#t.y -= arr2[randi()%3]
		p.set_translation(t)
		p.call_deferred("spawn")
		tile_passes = 0


func _on_trail_destroy_body_entered(body):
	if body.is_in_group("DESTROY"):
		body.queue_free()


func _on_trail_destroy_area_entered(area):
	if area.is_in_group("DESTROY"):
		area.queue_free()


func _on_container_body_exited(body):
	if not body.is_in_group("PLAYER"):
		body.queue_free()
	else:
		body.dead = true
		get_tree().set_pause(true)
		Globals.showing_main_menu = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_node("/root/test/startScreen/buttons/playButton").hide()
		get_node("/root/test/startScreen/buttons/restartButton").grab_focus()
		get_node("/root/test/startScreen").show()


func _on_move_right_pressed():
	get_node("%froggie3d").make_move_right()

func _on_move_left_pressed():
	get_node("%froggie3d").make_move_left()

func _on_move_jump_pressed():
	get_node("%froggie3d").make_move_jump()

func _on_move_jump_released():
	get_node("%froggie3d").make_move_land()


