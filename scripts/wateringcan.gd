extends basepickup

const droplet = preload("res://prefabs/water_drop.tscn")

@onready var nozzlepos = $nozzlepos
@onready var timer = $Timer

var watercount : float = 5
@export var maxwater : float = 20

var data : InventoryObject

func _ready():
	super()
	await get_tree().process_frame
	data = get_meta("obj").duplicate()
	set_meta("obj", data)
	if(data.customproperties.has("water")):
		watercount = data.customproperties["water"]
	else:
		watercount = 0
		data.customproperties["water"] = watercount
		set_meta("obj", data)

func _physics_process(delta):
	super(delta)
	if(nozzlepos.global_basis.z.dot(Vector3.DOWN) < -0.1):
		if(timer.is_stopped()):
			timer.start()
	else:
		if(!timer.is_stopped()):
			timer.stop()

func _on_timer_timeout():
	if(watercount > 0):
		watercount -= .1
		data.customproperties["water"] = watercount
		set_meta("obj", data)
		var drop = droplet.instantiate()
		get_tree().current_scene.add_child(drop)
		drop.global_position = nozzlepos.global_position - (nozzlepos.global_basis.z*.1)
		drop.apply_central_impulse(-nozzlepos.global_basis.z * 10)
		add_collision_exception_with(drop)
	else:
		watercount = 0

func water():
	watercount = clamp(watercount+.3, 0, maxwater)

func info() -> String:
	return ("%.1f" % watercount) + " / " + ("%.1f" % maxwater)
