extends RigidBody3D
class_name worm

func _physics_process(delta):
	apply_force(-global_basis.z*.5)
	apply_torque(global_basis.y * randf_range(-1,1)*.1)


func _on_death_timeout():
	queue_free()
