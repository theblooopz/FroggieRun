extends Node

var hot_restart = false

func _ready():
	set_process_input(true)

func _input(event):
	
	if event.is_action_pressed("cmd_restart") and hot_restart:
		get_tree().set_pause(false)
		get_tree().reload_current_scene()
	
	if event.is_action_pressed("cmd_fullscreen"):
		var fs = OS.is_window_fullscreen()
		OS.set_window_fullscreen(not fs)
