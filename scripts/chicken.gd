extends RigidBody3D

@onready var anim = $AnimationPlayer
@onready var actiontimer = $actiontimer
@onready var eggtimer = $eggtimer
@onready var floorcast = $floorcast
@onready var audio : AudioStreamPlayer3D = $audio

@onready var chickmodel = $chickmodel
@onready var chickshape = $chickshape

@onready var midskeleton = $midskeleton
@onready var midshape = $midshape

@onready var adultmodel = $oldskeleton/adultmodel
@onready var oldmodel = $oldskeleton/oldmodel

@onready var oldskeleton = $oldskeleton
@onready var oldshape = $oldshape

@export var chickthumbnail : Texture2D
@export var midthumbnail : Texture2D
@export var oldthumbnail : Texture2D

@export var childsounds : Array[AudioStream]
@export var adultsounds : Array[AudioStream]

var EGG = load("res://prefabs/egg.tscn")
const BLOOD = preload("res://prefabs/bloodsplatter.tscn")
const BLOOD2 = preload("res://prefabs/bloodparticles.tscn")
var state : int = 0

var baseweight : float = .1
var weight : float = 0
var agestage : int = -1
var age : float = 0
var fertility : int = 0
var data : InventoryObject

#var eggtimer : int = 30
#var actiontimer : int = 30

func _ready():
	await get_tree().process_frame
	data = get_meta("obj").duplicate()
	if(data.customproperties.has("age")):
		age = data.customproperties["age"]
	updatedata()
	agecheck()

func _physics_process(delta):
	incubateeggs(delta)

func straighten():
	apply_central_impulse(Vector3.UP*3)
	#global_rotation.x = 0
	#global_rotation.z = 0
	var strength = 1
	match agestage:
		0: strength = .2
		1: strength = .5
		2: strength = 1
	apply_torque_impulse((global_basis.x * (-global_rotation.x))*strength)
	apply_torque_impulse((global_basis.z * (-global_rotation.z))*strength)

func jump():
	#global_basis = global_basis.rotated(global_basis.y, randf_range(-PI,PI))
	if(global_basis.y.dot(Vector3.UP) < 0.1):
		straighten()
	else:
		var strength = .7
		match agestage:
			0: strength = .2
			1: strength = .5
			2: strength = .7
		apply_torque_impulse((global_basis.y * randf_range(-PI,PI))*strength)
		await get_tree().create_timer(.07).timeout
		apply_central_impulse((-global_basis.z*2) + (global_basis.y*2))

func jumptowards(node):
	if(global_basis.y.dot(Vector3.UP) < 0.1):
		straighten()
	else:
		var dir = global_position.direction_to(node.global_position)
		var perp = global_basis.z.cross(dir)
		var lr = -perp.dot(global_basis.y)
		apply_torque_impulse(global_basis.y * lr)
		apply_central_impulse((dir * 2) + (global_basis.y*2))

func _on_actiontimer_timeout():
	if(randi_range(0,20) == 0):
		match agestage:
			0:
				audio.stream = childsounds.pick_random()
				audio.play()
			1,2,3,4:
				audio.stream = adultsounds.pick_random()
				audio.play()
	match(state):
		0:
			if(!floorcast.is_colliding()):
				state = 1
				anim.play("air")
			else:
				if(randi_range(0,5) == 0):
					anim.play("RESET")
					anim.play("peck")
					actiontimer.start(randf_range(.8,1))
				else:
					var eg = getclosestegg()
					if(eg != null && agestage == 2):
						var distance = global_position.distance_to(eg.global_position)
						if(distance > 2 && distance < 20):
							jumptowards(eg)
							actiontimer.start(randf_range(.4,.6))
						else:
							jump()
							actiontimer.start(randf_range(.5,1))
					else:
						jump()
						actiontimer.start(randf_range(.5,1))
		1:
			if(floorcast.is_colliding()):
				state = 0
				anim.play("idle")

func _on_agetimer_timeout():
	age += .1
	updatedata()
	agecheck()

func agecheck():
	if(age < 10 && agestage != 0):
		eggtimer.stop()
		agestage = 0
		baseweight = .1
		chickmodel.visible = true
		chickshape.disabled = false
		midskeleton.visible = false
		midshape.disabled = true
		oldskeleton.visible = false
		oldshape.disabled = true
		var shape : BoxShape3D = chickshape.shape.duplicate()
		shape.size *= 1.1
		floorcast.shape = shape
	elif(age >= 10 && age < 20 && agestage != 1):
		eggtimer.stop()
		agestage = 1
		baseweight = .5
		oldskeleton.scale = Vector3.ONE * (weight+1)
		oldskeleton.visible = false
		oldshape.disabled = true
		midskeleton.visible = true
		midshape.disabled = false
		chickmodel.visible = false
		chickshape.disabled = true
		var shape : BoxShape3D = oldshape.shape.duplicate()
		shape.size *= 1.1
		floorcast.shape = shape
	elif(age >= 20 && age < 50 && agestage != 2):
		eggtimer.start()
		agestage = 2
		baseweight = 1
		oldskeleton.scale = Vector3.ONE * (weight+1)
		oldskeleton.visible = true
		adultmodel.visible = true
		oldmodel.visible = false
		oldshape.disabled = false
		midskeleton.visible = false
		midshape.disabled = true
		chickmodel.visible = false
		chickshape.disabled = true
		var shape : BoxShape3D = oldshape.shape.duplicate()
		shape.size *= 1.1
		floorcast.shape = shape
	elif(age >= 50 && age < 70 && agestage != 3):
		eggtimer.stop()
		agestage = 3
		baseweight = 1
		oldskeleton.scale = Vector3.ONE * (weight+1)
		oldskeleton.visible = true
		adultmodel.visible = false
		oldmodel.visible = true
		oldshape.disabled = false
		midskeleton.visible = false
		midshape.disabled = true
		chickmodel.visible = false
		chickshape.disabled = true
		var shape : BoxShape3D = oldshape.shape.duplicate()
		shape.size *= 1.1
		floorcast.shape = shape
	elif(age >= 70):
		die() #FUCKING DIE OF OLD AGE

func murder():
	die()

func die():
	var meat = Library.objs["chickenmeat"].instantiate()
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

func updatedata():
	if(data == null):
		data = get_meta("obj").duplicate()
	match agestage:
		0: data.icon = chickthumbnail
		1: data.icon = midthumbnail
		2: data.icon = oldthumbnail
	data.customproperties["age"] = age
	data.weight = baseweight + weight
	set_meta("obj", data)

func _on_animation_player_animation_finished(anim_name):
	if(anim_name == "peck"):
		anim.play("idle")

func fertilize():
	fertility = 3

func incubateeggs(delta):
	for n in get_tree().get_nodes_in_group("egg"):
		if(global_position.distance_to(n.global_position) <= 2):
			n.incubate(delta)

func getclosestegg():
	var eg
	for n in get_tree().get_nodes_in_group("egg"):
		if((eg == null || global_position.distance_to(eg.global_position) > global_position.distance_to(n.global_position)) && n.fertile):
			eg = n
	return eg

func _on_eggtimer_timeout():
	var eg = EGG.instantiate()
	eg.fertile = fertility > 0
	if(fertility >= 0):
		fertility -= 1
	get_tree().current_scene.add_child(eg)
	eg.global_position = global_position
	eggtimer.start(randf_range(26,39))

func info() -> String:
	var ret : String = "Age: %s\nFemale" % [str(age).pad_decimals(2)]
	return ret

func trigger(pl : PlayerCam):
	if(agestage == 0):
		pl.body.feed(10)
		queue_free()
