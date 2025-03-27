extends Area3D


func _on_body_entered(body: Node3D) -> void:
	if(body is Player):
		body.underwater = true
	if(body.is_in_group("fish")):
		body.queue_free()

func _on_body_exited(body: Node3D) -> void:
	if(body is Player):
		body.underwater = false
