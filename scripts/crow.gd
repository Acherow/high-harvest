extends RigidBody3D

@onready var anim = $AnimationPlayer

var flying : bool = false

var target

var fleeing : bool = false
var targetpos : Vector3

var rotationdirection : Vector3
var targetfly : Vector3

const BLOOD = preload("res://prefabs/bloodsplatter.tscn")
const BLOOD2 = preload("res://prefabs/bloodparticles.tscn")

func _ready():
	anim.play("idle")
	target = closestcrop()
	if(target != null):
		changemode()

func changemode():
	flying = !flying
	gravity_scale = 1 if !flying else 0

func _physics_process(delta):
	apply_central_force(targetfly * 10)

func act():
	if(fleeing):
		if(!flying):
			changemode()
		fly(targetpos - global_position)
		if(targetpos.distance_to(global_position) < 6):
			queue_free()
	else:
		if(target == null):
			targetfly = Vector3.ZERO
			jump()
			target = closestcrop()
		if(target != null && global_position.distance_to(target.global_position) < 1):
			targetfly = Vector3.ZERO
			anim.play("peck")
			if(flying):
				changemode()
			#target.queue_free()
			if(target.curtime < target.maxgrowtime):
				target.curwetness *= .95
				target.curtime *= .95
			target = null
		if(target != null && global_position.distance_to(target.global_position) < 10):
			if(flying):
				changemode()
				anim.play("idle")
			jump(target)
		elif(target != null):
			if(!flying):
				changemode()
				apply_central_impulse(Vector3.UP*5)
			else:
				fly(target.global_position - global_position)

func fly(dir : Vector3):
	var localdir = (linear_velocity).direction_to(dir)
	rotationdirection = dir.normalized()
	rotationdirection.y = 0
	if(localdir.y > 0):
		anim.play("flap")
	else:
		anim.play("hover")
	targetfly = localdir.normalized() + (dir.normalized()*.6)

func look_follow(state: PhysicsDirectBodyState3D, target_dir: Vector3) -> void:
	global_basis = global_basis.looking_at(target_dir)
	#var forward_dir: Vector3 = -global_basis.z
	#var local_speed: float = clampf(.1, 0, acos(forward_dir.dot(target_dir)))
	#if forward_dir.dot(target_dir) > 1e-4:
		#state.angular_velocity = local_speed * forward_dir.cross(target_dir) / state.step

func _integrate_forces(state):
	if(!rotationdirection.is_zero_approx()):
		look_follow(state, rotationdirection)

func jump(node = null):
	if(node != null):
		var dir = global_position.direction_to(node.global_position)
		var perp = global_basis.z.cross(dir)
		var lr = -perp.dot(global_basis.y)
		apply_torque_impulse(global_basis.y * lr)
		apply_central_impulse((dir * 1) + (global_basis.y*.5))
	else:
		rotationdirection = (-global_basis.z * randf_range(-PI,PI))
		await get_tree().process_frame
		apply_central_impulse((-global_basis.z*1) + (global_basis.y*.5))

func checkscare():
	var scares = get_tree().get_nodes_in_group("scarecrow").filter(func(a): return a.global_position.distance_to(global_position) < 15)
	if(!scares.is_empty()): 
		if(randi_range(0,10) == 0):
			scareoff()
			return
	if(global_position.distance_to(get_tree().get_first_node_in_group("player").global_position) < 20):
		scareoff()

func scareoff():
	fleeing = true
	targetpos = Vector3(randf_range(-1,1),0,randf_range(-1,1)).normalized() * 100 + Vector3.UP * 40

func closestcrop():
	var crops = get_tree().get_nodes_in_group("diggable").filter(func(a): return a is crop)
	var curcrop
	for n in crops:
		if(curcrop == null || curcrop.global_position.distance_to(global_position) > n.global_position.distance_to(global_position)):
			curcrop = n
	return curcrop

func murder():
	die()

func die():
	var meat = Library.objs["crowmeat"].instantiate()
	get_tree().current_scene.add_child(meat)
	meat.global_position = global_position
	meat.global_rotation = global_rotation
	var splatter = BLOOD.instantiate()
	get_tree().current_scene.add_child(splatter)
	splatter.global_position = global_position
	splatter.global_rotation = global_rotation
	splatter.rotation_degrees.y = randi_range(-180,180)
	var bloo = BLOOD2.instantiate()
	get_tree().current_scene.add_child(bloo)
	bloo.global_position = global_position
	bloo.global_rotation = global_rotation
	bloo.rotation_degrees.y = randi_range(-180,180)
	queue_free() 
