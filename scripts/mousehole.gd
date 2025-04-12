extends Area3D

var ratcount : int = 0

var ignore

@onready var timer = $Timer

func spawnrat():
	var rt = Library.objs["rat"].instantiate()
	ignore = rt
	get_tree().current_scene.add_child(rt)
	rt.global_position = global_position
	ratcount -= 1

func _on_body_entered(body):
	if(body is rat && body != ignore):
		ratcount += 1
		body.queue_free()

func _on_body_exited(body):
	if(body == ignore):
		ignore = null


func _on_timer_timeout():
	timer.start(randi_range(40,80))
	if(get_tree().get_first_node_in_group("food") != null):
		spawnrat()
