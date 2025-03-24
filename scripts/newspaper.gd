extends RigidBody3D
class_name newspaper

@onready var textstuff = $textstuff
@onready var listcont: GridContainer = $textstuff/ColorRect/ColorRect/GridContainer
@onready var date: Label = $textstuff/ColorRect/ColorRect/date

var plref
var data : InventoryObject

var writtenquests : Array[Array] #= [["PENIS METAL", "IT COMES FOR YOUR PENER,",1,69,true]]
#[title, desc, progress, goal, checkamount]
func _ready():
	textstuff.visible = false
	await get_tree().process_frame
	data = get_meta("obj").duplicate()
	if(data.customproperties.has("writtenquests")):
		writtenquests = data.customproperties["writtenquests"]
		date.text = "day " + data.customproperties["day"]
	else:
		data.customproperties["writtenquests"] = writtenquests
		data.customproperties["day"] = Savedata.gamedata["day"]
		date.text = "day %d" % data.customproperties["day"]
	set_meta("obj", data)
	
	var objs = listcont.get_children()
	var used = objs.duplicate()
	for n in writtenquests.size():
		objs[n].setup(writtenquests[n])
		used.erase(objs[n])
	for i in used:
		i.queue_free()

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

func updatedata():
	if(data == null):
		data = get_meta("obj").duplicate()
	data.customproperties["writtenquests"] = writtenquests
	set_meta("obj", data)
