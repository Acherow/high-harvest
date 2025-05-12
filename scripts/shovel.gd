extends basepickup

var pl : PlayerCam
@onready var anim = $AnimationPlayer
@onready var audio: AudioStreamPlayer3D = $AudioStreamPlayer3D

const hole = preload("res://prefabs/crops/hole.tscn")

func hold(holder):
	pl = holder

func trigger(pl):
	anim.play("dig")

func candrop() -> bool:
	return !anim.is_playing()

func dig():
	if(pl.cast.is_colliding()):
		if(pl.cast.get_collider().is_in_group("diggable")):
			var point = pl.cast.get_collision_point()
			var space := get_world_3d().direct_space_state
			var query = PhysicsShapeQueryParameters3D.new()
			var sphere = SphereShape3D.new()
			sphere.radius = .1
			query.shape = sphere
			query.transform.origin = point
			var cols = space.intersect_shape(query)
			for n in cols:
				if(n.collider.has_method("uproot")):
					n.collider.uproot()
					audio.play()
					return
			
			var wormcount = clamp(randi_range(-20,4),0,4)
			for w in wormcount:
				var wom = Library.critters["worm"].instantiate()
				get_tree().current_scene.add_child(wom)
				wom.global_position = point
				wom.global_rotation_degrees.y = randi_range(-180,180)
			var hol = hole.instantiate()
			get_tree().current_scene.add_child(hol)
			hol.global_position = point
			audio.play()
