extends RigidBody3D
@onready var childshape: CollisionShape3D = $childshape
@onready var teenagershape: CollisionShape3D = $teenagershape
@onready var adultshape: CollisionShape3D = $adultshape
@onready var childmodel: Node3D = $child
@onready var teenagermodel: Node3D = $teenager
@onready var adultskeleton: Node3D = $adult
@onready var adultmodel: MeshInstance3D = $adult/Skeleton3D/pig
@onready var oldmodel: MeshInstance3D = $adult/Skeleton3D/oldpig
@onready var floorcast : ShapeCast3D = $floorcast
@onready var anim = $AnimationPlayer
@onready var audio = $audio

@export var adultsounds : Array[AudioStream]

const BLOOD = preload("res://prefabs/bloodsplatter.tscn")
const BLOOD2 = preload("res://prefabs/bloodparticles.tscn")

var baseweight : float = .1
var weight : float = 0
var agestage : int = 0
var age : float = 0
var sexmale : bool = false
var data : InventoryObject

var canfuck : int = 20

func _ready():
	sexmale = [true,false].pick_random()
	await get_tree().process_frame
	data = get_meta("obj").duplicate()
	if(data.customproperties.has("age")):
		age = data.customproperties["age"]
	if(data.customproperties.has("sex")):
		sexmale = data.customproperties["sex"]
	updatedata()
	agecheck()

func _physics_process(delta):
	if(curdir != Vector3.ZERO && global_basis.y.dot(Vector3.UP) > 0.1):
		sleeping = false
		apply_force(curdir * 30, (-basis.y*.2)+(-basis.z*.5))

func straighten():
	anim.play("idle")
	apply_central_impulse(Vector3.UP*5)
	var strength = 1
	match agestage:
		0: strength = .4
		1: strength = .7
		2: strength = 1.1
	apply_torque_impulse((global_basis.x * (-global_rotation.x))*strength)
	apply_torque_impulse((global_basis.z * (-global_rotation.z))*strength)

func murder():
	die()

func die():
	var meat = Library.objs["pigmeat"].instantiate()
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

func _on_agetimer_timeout():
	age += .2
	if(canfuck > 0):
		canfuck -= 1
	#age += 10
	updatedata()
	agecheck()

func agecheck():
	if(age < 10 && agestage != 0):
		agestage = 0
	elif(age >= 10 && age < 20 && agestage != 1):
		agestage = 1
	elif(age >= 20 && age < 50 && agestage != 2):
		agestage = 2
	elif(age >= 50 && age < 70 && agestage != 3):
		agestage = 3
	elif(age >= 70):
		die() #FUCKING DIE OF OLD AGE
	
	match agestage:
		0:
			childshape.disabled = false
			childmodel.visible = true
			teenagershape.disabled = true
			teenagermodel.visible = false
			adultshape.disabled = true
			adultskeleton.visible = false
			adultmodel.visible = false
			oldmodel.visible = false
			var shape : BoxShape3D = childshape.shape.duplicate()
			shape.size *= 1.1
			floorcast.shape = shape
		1:
			childshape.disabled = true
			childmodel.visible = false
			teenagershape.disabled = false
			teenagermodel.visible = true
			adultshape.disabled = true
			adultskeleton.visible = false
			adultmodel.visible = false
			oldmodel.visible = false
			var shape : BoxShape3D = teenagershape.shape.duplicate()
			shape.size *= 1.1
			floorcast.shape = shape
		2:
			childshape.disabled = true
			childmodel.visible = false
			teenagershape.disabled = true
			teenagermodel.visible = false
			adultshape.disabled = false
			adultskeleton.visible = true
			adultmodel.visible = true
			oldmodel.visible = false
			var shape : BoxShape3D = adultshape.shape.duplicate()
			shape.size *= 1.1
			floorcast.shape = shape
			add_to_group("heavy")
		3:
			childshape.disabled = true
			childmodel.visible = false
			teenagershape.disabled = true
			teenagermodel.visible = false
			adultshape.disabled = false
			adultskeleton.visible = true
			adultmodel.visible = false
			oldmodel.visible = true
			var shape : BoxShape3D = adultshape.shape.duplicate()
			shape.size *= 1.1
			floorcast.shape = shape

var curdir = Vector3.ZERO
func _on_actiontimer_timeout():
	if(randi_range(0,20) == 0):
		audio.stream = adultsounds.pick_random()
		audio.play()
	if(!floorcast.is_colliding()):
		anim.play("idle")
		curdir = Vector3.ZERO
		return
	
	if(curdir != Vector3.ZERO):
		anim.play("idle")
		curdir = Vector3.ZERO
	else:
		if(global_basis.y.dot(Vector3.UP) < 0.1):
			straighten()
		else:
			var pig = getclosestpig()
			if(pig == null || canfuck > 0 || agestage != 2 || sexmale != false):
				anim.play("walk")
				curdir = -global_basis.z.rotated(Vector3.UP, randf_range(-1,1)).normalized()
			else:
				fuck(pig)
			#curdir = Vector3(randf_range(-1,1),0,randf_range(-1,1)).normalized()

func updatedata():
	if(data == null):
		data = get_meta("obj").duplicate()
	data.customproperties["age"] = age
	data.customproperties["sex"] = sexmale
	data.weight = baseweight + weight
	set_meta("obj", data)

func info() -> String:
	var ret : String = "Age: %s\n%s" % [age, "Male" if sexmale else "Female"]
	return ret

func getclosestpig():
	var ch
	var list : Array = get_tree().get_nodes_in_group("pig")
	list = list.filter(func(a): return a.sexmale != sexmale && a.canfuck == 0 && a.agestage == 2 && a.global_position.distance_to(global_position) < 10)
	if(list.is_empty()):
		return null
	for n in list:
		if((ch == null || global_position.distance_to(ch.global_position) > global_position.distance_to(n.global_position))):
			ch = n
	return ch

func fuck(tg):
	canfuck = 20
	tg.canfuck = 20
	var kid = load("res://prefabs/pig.tscn").instantiate()
	get_tree().current_scene.add_child(kid)
	kid.global_position = tg.global_position - global_position
