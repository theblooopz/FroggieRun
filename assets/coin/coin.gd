extends Area


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	queue_free()


func _on_coin_body_entered(body):
	if body.is_in_group("PLAYER"):
		$sfx_coin.play()
		Globals.add_coin()
		set_deferred("set_monitoring", false)
		hide()
		$Timer.start()
