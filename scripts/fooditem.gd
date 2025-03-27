extends basepickup
class_name fooditem

@export var model : MeshInstance3D

var data : InventoryObject

var age : float = 0
var cooktime : float = 0

var cooking : bool = false

@export var mats : Array[Material]
@export var rotmats : Array[Material]
@export var cookedmats : Array[Material]
@export var burntmats : Array[Material]

@export var fillamount : float
@export var cookedfillamount : float
@export var maxage : float = 30
@export var maxcooktime : float = 10
@export var burntime : float = 20

var pl : PlayerCam
func grabbed(p):
	pl = p

func _ready():
	if(model == null):
		model = $model
	super()
	await get_tree().process_frame
	data = get_meta("obj").duplicate()
	if(data.customproperties.has("age")):
		age = data.customproperties["age"]
	if(data.customproperties.has("cooking")):
		cooktime = data.customproperties["cooking"]
	if(age >= maxage && maxage > 0):
		data.name = "Spoiled food"
	updatedata()
	updatemats()

func trigger(pla : PlayerCam):
	var amt = fillamount
	if(cooktime >= maxcooktime && cooktime < burntime):
		amt = cookedfillamount
	if((age >= maxage && maxage > 0) || cooktime >= burntime):
		amt = -1
	pla.body.feed(amt)
	if(age >= maxage && maxage > 0):
		pla.body.ragdoll()
	queue_free()

func updatedata():
	if(data == null):
		data = get_meta("obj").duplicate()
	data.customproperties["age"] = age
	data.customproperties["cooking"] = cooktime
	if(age >= maxage && maxage > 0):
		data.customproperties["sellmod"] = "spoiled food"
	set_meta("obj", data)

func updatemats():
	for n in mats.size():
		if(cooktime >= burntime):
			model.set_surface_override_material(n,burntmats[n])
		elif(age >= maxage && maxage != -1):
			model.set_surface_override_material(n,rotmats[n])
		elif(cooktime >= maxcooktime && cooktime < burntime):
			model.set_surface_override_material(n,cookedmats[n])
		else:
			model.set_surface_override_material(n,mats[n])

func _on_agingtimer_timeout():
	if(age < maxage):
		age += .1
	elif(maxage > 0):
		data.name = "Spoiled food"
	updatemats()

func _physics_process(delta):
	if(cooking):
		cooktime += delta
		if(pl):
			pl.letgoofgrabbed()

func heat(on):
	updatemats()
	cooking = on
