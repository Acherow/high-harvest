extends RigidBody3D
class_name storeflyer

@onready var textstuff = $textstuff

@export var slots : Array[Control]

var buyingselection : Dictionary

var plref
var data : InventoryObject
var hovered

func _ready():
	textstuff.visible = false
	await get_tree().process_frame
	data = get_meta("obj").duplicate()
	set_meta("obj", data)
	
	var curpurs : Dictionary = Library.purchasables.duplicate()
	curpurs.merge(Savedata.gamedata["unlocks"])
	
	for n in slots:
		var pur = curpurs.keys().pick_random()
		curpurs.erase(pur)
		n.setup(Library.invobjs[pur])
		n.mouse_entered.connect(func(): hovered = n)
		n.mouse_exited.connect(func(): hovered = null)

func trigger(pl):
	plref = pl
	if(pl.inventory.visible):
		return
	
	var on = !textstuff.visible
	pl.camfrozen = on
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED if !on else Input.MOUSE_MODE_VISIBLE)
	textstuff.visible = on
	if(!on):
		plref = null

func _input(event):
	if(plref && textstuff.visible && (event.is_action_pressed("pause")||event.is_action_pressed("inventory") || event.is_action_pressed("grab") || event.is_action_pressed("hold"))):
		plref.camfrozen = false
		textstuff.visible = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if(hovered && event.is_action_pressed("leftclick")):
		addpurchase(hovered.itemobj.objaddress)
	if(hovered && event.is_action_pressed("rightclick")):
		removepurchase(hovered.itemobj.objaddress)

func addpurchase(item):
	if(!buyingselection.has(item)):
		buyingselection[item] = 0
	buyingselection[item] += 1
	hovered.numb(buyingselection[item])

func removepurchase(item):
	if(buyingselection.has(item)):
		buyingselection[item] -= 1
		buyingselection[item] = clampi(buyingselection[item], 0, 99)
		hovered.numb(buyingselection[item])
	else:
		hovered.numb(0)

func updatedata():
	if(data == null):
		data = get_meta("obj").duplicate()
	set_meta("obj", data)
