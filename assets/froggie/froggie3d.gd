extends KinematicBody

const GRAVITY = 4
const JUMP_POWER = 8

var camrot_h = 0
var camrot_v = 0
var cam_v_max = PI/2
var cam_v_min = -PI/2
var h_sensitivity = 0.005
var v_sensitivity = 0.005
var h_acceleration = 5
var v_acceleration = 15

var move = Vector3.ZERO
var step_sounds

var landed = true
var dead = false

func _ready():
	if not Globals.hot_restart: set_process_input(false)
	
	step_sounds = [
		$sfx_step1,
		$sfx_step2,
		$sfx_step3,
		$sfx_step4
	]

func play():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	set_physics_process(true)
	set_process_input(true)
	get_node("arm/Camera").set_current(true)
	$state["parameters/conditions/play"]  = true
	
	Globals.hot_restart = true
	Globals.playing = true
	
	$state["parameters/Run/Run/TimeScale/scale"] = 1.5
	$state["parameters/Run/Run 2/TimeScale/scale"] = 1.5

func _input(event):
	
	if event.is_action_pressed("move_jump"):
		if $ground_ray.is_colliding() and $jump_timer.is_stopped() and $move_left.is_stopped() and $move_right.is_stopped():
			$jump_timer.start()
			$sfx_jump.play()
			$state["parameters/conditions/jump"]  = true
			$state["parameters/conditions/run"]  = false
	
	if event.is_action_released("move_jump"):
		if not $jump_timer.is_stopped():
			$jump_timer.stop()
			_on_jump_timer_timeout()
	
	if event.is_action_pressed("move_left"):
		if $move_left.is_stopped() and $move_right.is_stopped():
			$move_left.start()
	
	if event.is_action_pressed("move_right"):
		if $move_right.is_stopped() and $move_left.is_stopped():
			$move_right.start()
	
	
	###################################
	
	if event is InputEventMouseMotion:
		$mouse_control_stay_delay.start()
		camrot_h -= event.relative.x * h_sensitivity
		camrot_v += event.relative.y * v_sensitivity
	
func _physics_process(delta):
	
	########################
	
	camrot_v = clamp(camrot_v, cam_v_min, cam_v_max)
	
	var mesh_front = -get_node("Froggie").global_transform.basis.z
	var rot_speed_multiplier = 0.15 #reduce this to make the rotation radius larger
	var auto_rotate_speed =  (PI - mesh_front.angle_to($arm.global_transform.basis.z)) * move.length() * rot_speed_multiplier

	if $mouse_control_stay_delay.is_stopped():
		#FOLLOW CAMERA
		$arm.rotation.y = lerp_angle($arm.rotation.y, get_node("Froggie").global_transform.basis.get_euler().y, delta * auto_rotate_speed)

	else:
		pass
		#MOUSE CAMERA
		var lerp_y = lerp($arm.get_rotation().y, camrot_h, delta * h_acceleration)
		$arm.set_rotation(Vector3($arm.get_rotation().x, lerp_y, $arm.get_rotation().z))
	
	var lerp_x = lerp($arm.get_rotation().x, camrot_v, delta * v_acceleration)
	$arm.set_rotation(Vector3(lerp_x, $arm.get_rotation().y, $arm.get_rotation().z))
	
	############################################

	if not $ground_ray.is_colliding():
		move.y -= GRAVITY
		landed = false
	else:
		move.y = 0
		if not landed:
			$sfx_land.play()
			landed = true
		
	if not $jump_timer.is_stopped():
		move.y += JUMP_POWER
		
	if not $move_left.is_stopped():
		move.x -= 0.5
		var rot = get_node("Froggie/Skeleton/Froggie_mesh").get_rotation()
		rot.y = lerp(rot.y, deg2rad(45),0.1)
		get_node("Froggie/Skeleton/Froggie_mesh").set_rotation(rot)
		
	if not $move_right.is_stopped():
		move.x += 0.5
		var rot2 = get_node("Froggie/Skeleton/Froggie_mesh").get_rotation()
		rot2.y = lerp(rot2.y, deg2rad(-45),0.1)
		get_node("Froggie/Skeleton/Froggie_mesh").set_rotation(rot2)
		
	
	if $move_right.is_stopped() and $move_left.is_stopped():
		var rot1 = get_node("Froggie/Skeleton/Froggie_mesh").get_rotation()
		rot1.y = lerp(rot1.y, deg2rad(0),0.1)
		get_node("Froggie/Skeleton/Froggie_mesh").set_rotation(rot1)

	move = move_and_slide(move, Vector3.UP, false)
	
	
	#################################
	
	if $front_ray.is_colliding():
		var col = $front_ray.get_collider()
		if col.is_in_group("MOVE"):
			var n = $front_ray.get_collision_normal()*-1
			col.apply_impulse($front_ray.get_collision_point(), n)
		if col.is_in_group("DEATH"):
			make_dead()

func make_dead():
	Globals.playing = false
	$state["parameters/conditions/dead"] = true

func play_step():
	if $ground_ray.is_colliding():
		var r = randi() % 4
		step_sounds[r].play()

func _on_jump_timer_timeout():
	$state["parameters/conditions/jump"]  = false
	$state["parameters/conditions/run"]  = true


func _on_move_left_timeout():
	move.x = 0


func _on_move_right_timeout():
	move.x = 0
