extends StaticBody3D

var seated
@onready var seatpos = $seatpos
@onready var truck: RigidBody3D = $".."
@onready var start = $"../start"

func grabtrigger(pl : Player):
	start.play()
	pl.reparent(self)
	var p : CollisionShape3D
	pl.frozen = true
	pl.crouchheight(true)
	seated = pl
	truck.add_collision_exception_with(seated)
	if(pl.cam.held != null):
		add_collision_exception_with(pl.cam.held)
		truck.add_collision_exception_with(pl.cam.held)
	pl.global_position = seatpos.global_position
	pl.global_rotation = global_rotation
	pl.cam.forceupdaterotation()
	#add_collision_exception_with(seated)

func _input(event):
	if(seated != null && event.is_action_pressed("jump")):
		var pos = seated.global_position
		seated.call_deferred("reparent",get_tree().current_scene)
		await get_tree().process_frame
		seated.global_position = pos
		truck.remove_collision_exception_with(seated)
		#remove_child(seated)
		if(seated.cam.held):
			remove_collision_exception_with(seated.cam.held)
			truck.remove_collision_exception_with(seated.cam.held)
		seated.frozen = false
		seated.uncrouchqueued = true
		seated = null

func info():
	return "Sit down?"
