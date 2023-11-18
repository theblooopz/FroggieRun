extends Node

var hot_restart = false
var coins = 0
var playing = false


func _ready():
	set_process_input(true)

func add_coin():
	coins += 1
	get_node("/root/test/hud/Label").set_text(str(coins))

func _input(event):
	
	if event.is_action_pressed("cmd_restart") and hot_restart:
		coins = 0
		playing = true
		get_tree().set_pause(false)
		get_tree().reload_current_scene()
	
	if event.is_action_pressed("cmd_fullscreen"):
		var fs = OS.is_window_fullscreen()
		OS.set_window_fullscreen(not fs)
