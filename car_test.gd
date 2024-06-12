extends VehicleBody3D



func _physics_process(delta):
	steering = lerp(steering, Input.get_axis("right","left") * 0.4, 5 * delta)
	engine_force = Input.get_axis("back","forward") *2500
	
var triggerRecover = false

func _input(ev):
	if Input.is_key_pressed(KEY_K):
		triggerRecover = true
	



func _integrate_forces(state):
	#https://gamedevacademy.org/physicsdirectbodystate3d-in-godot-complete-guide/
	var local_speed = state.angular_velocity + state.linear_velocity
	if triggerRecover == true and local_speed < Vector3 (.01,.01,.01):
		var new_transform = state.transform
		new_transform.basis = Basis(Vector3(0, 0, 0).normalized(), -1)
		state.transform = new_transform
		var velocity = state.linear_velocity
		velocity = Vector3(0, 0, 0)
		state.linear_velocity = velocity
		triggerRecover = false 
		pass
		
