extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	
	get_node("buttons/playButton").grab_focus()
	
	set_process_input(true)
	if Globals.hot_restart:
		hide()
		get_node("/root/test/hud").show()
		get_node("buttons/restartButton").show()
		get_node("buttons/playButton").set_text("Continue")
		get_node("%froggie3d").play()
		
	

func _input(event):
	if event.is_action_pressed("cmd_menu"):
		
		if Globals.showing_main_menu: return
		
		if not is_visible():
			get_tree().set_pause(true)
			get_node("buttons/playButton").grab_focus()
			show()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
		else:
			get_tree().set_pause(false)
			hide()
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_quitButton_pressed():
	get_tree().quit()


func _on_playButton_pressed():
	Globals.showing_main_menu = false
	get_tree().set_pause(false)
	get_node("%hud").show()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if Globals.hot_restart:
		hide()
	else:
		hide()
		get_node("buttons/restartButton").show()
		get_node("buttons/playButton").set_text("Continue")
		get_node("%froggie3d").play()


func _on_restartButton_pressed():
	if Globals.hot_restart:
		Globals.coins = 0
		Globals.playing = true
		Globals.showing_main_menu = false
		get_tree().set_pause(false)
		get_tree().reload_current_scene()


func _on_button_mouseover():
	$sfx.play()
