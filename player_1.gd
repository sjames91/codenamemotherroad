extends VehicleBody3D

@onready var camera_pivot = $CameraPivot
@onready var camera_3d = $CameraPivot/Camera3D
@onready var reverse_camera_3d = $CameraPivot/ReverseCamera3D


var triggerRecover = false
var max_rpm = 5000
var max_torque = 200
var max_steer = 0.8
var look_at

# Called when the node enters the scene tree for the first time.
func _ready():
	look_at = global_position
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass





func _physics_process(delta):
	
	# Vehicle movement
	steering = move_toward(steering, Input.get_axis("right", "left") * max_steer, delta * 2.5)
	var acceleration = Input.get_axis("back", "forward")
	var rpm = abs($B_LeftWheel.get_rpm())
	$B_LeftWheel.engine_force = acceleration * max_torque * (1 - rpm / max_rpm)
	rpm = abs($B_RightWheel.get_rpm())
	$B_RightWheel.engine_force = acceleration * max_torque * (1 - rpm / max_rpm)
	
	# Camera positioning
	camera_pivot.global_position = camera_pivot.global_position.lerp(global_position, delta * 20.0)
	camera_pivot.transform = camera_pivot.transform.interpolate_with(transform, delta * 5.0)
	look_at = look_at.lerp(global_position + linear_velocity, delta * 5.0)
	camera_3d.look_at(look_at)
	
	# Reverse Camera Positioning
	#reverse_camera_3d.look_at(look_at)
	#_check_camera_switch()
	#
#func _check_camera_switch():
	# Checks if our movement velocity vs global is greater or less than 90 deg to determine direction of movement
	#if linear_velocity.dot(transform.basis.z) > 0:
		#camera_3d.current = true
	#else:
		#reverse_camera_3d.current = true
		

# Set triggerRecover to true using key press. 
func _input(ev):
	if Input.is_key_pressed(KEY_K):
		triggerRecover = true
		
	



func _integrate_forces(state):
	# Fixes vehcile orientation
	if triggerRecover == true:
		var new_transform = state.transform
		new_transform.origin.y = new_transform.origin.y + 1
		#new_transform.origin
		#new_transform.basis = Vector3(0, 0, 0)
		new_transform.basis = Basis(Vector3(0, 1, 0).normalized(), 0)
		state.transform = new_transform
		
		var velocity = state.linear_velocity
		velocity = Vector3(0, 0, 0)
		state.linear_velocity = velocity
		triggerRecover = false

