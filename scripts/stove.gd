extends RigidBody3D

@onready var button01 :grabarea = $button01
@onready var button02 :grabarea = $button02
@onready var button03 :grabarea = $button03
@onready var button04 :grabarea = $button04
@onready var fires = [$fire1,$fire2,$fire3,$fire4]
var fuel : float = 20

var heated : Array[Array]

var properties : Dictionary

func _ready():
	heated.resize(4)
	add_collision_exception_with(button01)
	add_collision_exception_with(button02)
	add_collision_exception_with(button03)
	add_collision_exception_with(button04)
	button01.grabbed.connect(togglefire.bind(0))
	button02.grabbed.connect(togglefire.bind(1))
	button03.grabbed.connect(togglefire.bind(2))
	button04.grabbed.connect(togglefire.bind(3))
	await get_tree().process_frame
	if(has_meta("customproperties")):
		properties = get_meta("customproperties").duplicate()
	if(properties.has("fuel")):
		fuel = properties["fuel"]

func _on_area_entered(body,ar):
	if(body.has_method("heat")):
		heated[ar].append(body)
		if(fires[ar].emitting):
			body.heat(true)

func _on_area_exited(body,ar):
	if(body.has_method("heat")):
		body.heat(false)
	heated[ar].erase(body)

func togglefire(body,id : int):
	fires[id].emitting = !fires[id].emitting
	#print(id)
	for n in heated[id]:
		if(n.has_method("heat")):
			n.heat(fires[id].emitting)

func _process(delta):
	properties["fuel"] = fuel
	set_meta("customproperties",properties)
	if(fuel <= 0):
		for n in fires:
			n.emitting = false

func _physics_process(delta):
	for n in fires:
		n.visible = n.emitting
		if(n.emitting):
			fuel -= delta * .01

func filloil():
	fuel = 20

func info():
	return "%s / 20.0"%str(fuel).pad_decimals(1)
