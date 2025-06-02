extends StaticBody3D

var curobj

var on:bool = false

@onready var wat: MeshInstance3D = $MeshInstance3D

func grabtrigger(pl : Player):
	on = !on
	wat.visible = on

func _on_area_3d_body_entered(body):
	if(body.has_method("water")):
		curobj = body
		$Timer.start()

func _on_area_3d_body_exited(body):
	if(body == curobj):
		curobj = null

func _on_timer_timeout():
	if(curobj && curobj.has_method("water") && on):
		curobj.water()
