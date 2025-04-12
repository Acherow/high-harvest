extends JoltGeneric6DOFJoint3D

var length = .6

func _physics_process(delta):
	if(randi_range(0,100) == 0):
		set_param_x(PARAM_ANGULAR_MOTOR_TARGET_VELOCITY,randf_range(-length,length))
		set_param_z(PARAM_ANGULAR_MOTOR_TARGET_VELOCITY,randf_range(-length,length))
		#set_param_x(PARAM_ANGULAR_MOTOR_TARGET_VELOCITY,randf_range(-1,1))
