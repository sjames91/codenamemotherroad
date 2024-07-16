#extends VehicleBody3D
#
#@onready var camera_pivot = $CameraPivot
#@onready var camera_3d = $CameraPivot/Camera3D
#@onready var reverse_camera_3d = $CameraPivot/ReverseCamera3D
#
#
#var triggerRecover = false
#var max_rpm = 5000
#var max_torque = 200
#var max_steer = 0.8
#var look_at
#
## Called when the node enters the scene tree for the first time.
#func _ready():
	#look_at = global_position
	#pass # Replace with function body.
#
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
#
#
#
#
#
#func _physics_process(delta):
	#
	## Vehicle movement
	#steering = move_toward(steering, Input.get_axis("right", "left") * max_steer, delta * 2.5)
	#var acceleration = Input.get_axis("back", "forward")
	#var rpm = abs($B_LeftWheel.get_rpm())
	#$B_LeftWheel.engine_force = acceleration * max_torque * (1 - rpm / max_rpm)
	#rpm = abs($B_RightWheel.get_rpm())
	#$B_RightWheel.engine_force = acceleration * max_torque * (1 - rpm / max_rpm)
	#
	## Camera positioning
	#camera_pivot.global_position = camera_pivot.global_position.lerp(global_position, delta * 20.0)
	#camera_pivot.transform = camera_pivot.transform.interpolate_with(transform, delta * 5.0)
	#look_at = look_at.lerp(global_position + linear_velocity, delta * 5.0)
	#camera_3d.look_at(look_at)
	#
#
#
## Set triggerRecover to true using key press. 
#func _input(ev):
	#if Input.is_key_pressed(KEY_K):
		#triggerRecover = true
		#
	#
#
#
#
#func _integrate_forces(state):
	## Fixes vehcile orientation
	#if triggerRecover == true:
		#var new_transform = state.transform
		#new_transform.origin.y = new_transform.origin.y + 1
		##new_transform.origin
		##new_transform.basis = Vector3(0, 0, 0)
		#new_transform.basis = Basis(Vector3(0, 1, 0).normalized(), 0)
		#state.transform = new_transform
		#
		#var velocity = state.linear_velocity
		#velocity = Vector3(0, 0, 0)
		#state.linear_velocity = velocity
		#triggerRecover = false
extends VehicleBody3D

@onready var camera_pivot = $CameraPivot
@onready var camera_3d = $CameraPivot/Camera3D
@onready var reverse_camera_3d = $CameraPivot/ReverseCamera3D

var triggerRecover = false
var max_rpm = 5000
var max_torque = 200
var max_steer = 0.8
var look_at

func _ready():
	look_at = global_position
	# Adjust the center of mass
	center_of_mass = Vector3(0, -1, 0)  # Lower the center of mass further

func _physics_process(delta):
	# Vehicle movement
	steering = move_toward(steering, Input.get_axis("right", "left") * max_steer, delta * 2.5)
	var acceleration = Input.get_axis("back", "forward")
	var rpm_left = abs($B_LeftWheel.get_rpm())
	var rpm_right = abs($B_RightWheel.get_rpm())
	var engine_force = acceleration * max_torque * (1 - max(rpm_left, rpm_right) / max_rpm)
	$B_LeftWheel.engine_force = engine_force
	$B_RightWheel.engine_force = engine_force

	# Camera positioning
	camera_pivot.global_position = camera_pivot.global_position.lerp(global_position, delta * 20.0)
	camera_pivot.transform = camera_pivot.transform.interpolate_with(transform, delta * 5.0)
	look_at = look_at.lerp(global_position + linear_velocity, delta * 5.0)
	camera_3d.look_at(look_at)

	# Apply anti-roll force
	apply_anti_roll_force(delta)

func _input(ev):
	if Input.is_key_pressed(KEY_K):
		triggerRecover = true

func _integrate_forces(state):
	# Check if the vehicle is upside down (more than 90 degrees tilted)
	var up_vector = state.transform.basis.y
	var global_up_vector = Vector3(0, 1, 0)
	if up_vector.dot(global_up_vector) < 0:
		triggerRecover = true

	if triggerRecover == true:
		var new_transform = state.transform
		new_transform.origin.y = new_transform.origin.y + 1
		new_transform.basis = Basis(Vector3(0, 1, 0).normalized(), 0)
		state.transform = new_transform
		
		var velocity = state.linear_velocity
		velocity = Vector3(0, 0, 0)
		state.linear_velocity = velocity
		triggerRecover = false

func apply_anti_roll_force(delta):
	var suspension_stiffness = 10.0  # Adjusted stiffness to reduce wobble
	var left_travel = $B_LeftWheel.suspension_travel
	var right_travel = $B_RightWheel.suspension_travel
	var anti_roll_force = (left_travel - right_travel) * suspension_stiffness

	if $B_LeftWheel.is_in_contact() and $B_RightWheel.is_in_contact():
		apply_central_force(Vector3(0, anti_roll_force, 0))
		apply_central_force(Vector3(0, -anti_roll_force, 0))

##
#extends VehicleBody3D
#
#@onready var camera_pivot = $CameraPivot
#@onready var camera_3d = $CameraPivot/Camera3D
#@onready var reverse_camera_3d = $CameraPivot/ReverseCamera3D
#
#var triggerRecover = false
#var max_rpm = 5000
#var max_torque = 200
#var max_steer = 0.8
#var look_at
#
#func _ready():
	#look_at = global_position
	## Adjust the center of mass
	#center_of_mass = Vector3(0, -0.5, 0)
	#
	## Configure suspension parameters
	#configure_suspension($B_LeftWheel)
	#configure_suspension($B_RightWheel)
	#configure_suspension($F_LeftWheel)
	#configure_suspension($F_RightWheel)
#
#func _physics_process(delta):
	## Vehicle movement
	#steering = move_toward(steering, Input.get_axis("right", "left") * max_steer, delta * 2.5)
	#var acceleration = Input.get_axis("back", "forward")
	#var rpm_left = abs($B_LeftWheel.get_rpm())
	#var rpm_right = abs($B_RightWheel.get_rpm())
	#var engine_force = acceleration * max_torque * (1 - max(rpm_left, rpm_right) / max_rpm)
	#$B_LeftWheel.engine_force = engine_force
	#$B_RightWheel.engine_force = engine_force
#
	## Camera positioning
	#camera_pivot.global_position = camera_pivot.global_position.lerp(global_position, delta * 20.0)
	#camera_pivot.transform = camera_pivot.transform.interpolate_with(transform, delta * 5.0)
	#look_at = look_at.lerp(global_position + linear_velocity, delta * 5.0)
	#camera_3d.look_at(look_at)
#
	## Apply anti-roll force
	#apply_anti_roll_force()
#
#func _input(ev):
	#if Input.is_key_pressed(KEY_K):
		#triggerRecover = true
#
#func _integrate_forces(state):
	#if triggerRecover == true:
		#var new_transform = state.transform
		#new_transform.origin.y = new_transform.origin.y + 1
		#new_transform.basis = Basis(Vector3(0, 1, 0).normalized(), 0)
		#state.transform = new_transform
		#
		#var velocity = state.linear_velocity
		#velocity = Vector3(0, 0, 0)
		#state.linear_velocity = velocity
		#triggerRecover = false
#
#func apply_anti_roll_force():
	#var suspension_stiffness = 10.0
	#var left_travel = $B_LeftWheel.suspension_travel
	#var right_travel = $B_RightWheel.suspension_travel
	#var anti_roll_force = (left_travel - right_travel) * suspension_stiffness
#
	#if $B_LeftWheel.is_in_contact() and $B_RightWheel.is_in_contact():
		#apply_central_force(Vector3(0, anti_roll_force, 0))
		#apply_central_force(Vector3(0, -anti_roll_force, 0))
#
#func configure_suspension(wheel):
	#wheel.suspension_stiffness = 20.0  # Increase stiffness
	#wheel.damping_compression = 4.0  # Increase damping to prevent bounciness
	#wheel.damping_relaxation = 4.0  # Increase damping to prevent bounciness
	#wheel.suspension_travel = 0.1  # Set travel limit to prevent excessive movement

