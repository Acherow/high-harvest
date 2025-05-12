extends basepickup
class_name box

@onready var lidcheck = $lidcheck
@onready var grabarea = $grabarea
@onready var lidshape = $lidshape

var lid

var inventory : Array[InventoryObject]

var data : InventoryObject

@export var maxweight : float = 5

func _ready():
	super()
	grabarea.grabbed.connect(removeitem)
	await get_tree().process_frame
	data = get_meta("obj").duplicate()
	if(data.customproperties.has("inventory") && inventory.is_empty()):
		inventory = deserializeinventory(data.customproperties["inventory"])
	#if((data.customproperties.has("lid") && data.customproperties["lid"] == true) || !data.customproperties.has("lid")):
	#	var l = Library.objs["boxlid"].instantiate()
	#	get_tree().current_scene.add_child(l)
	#	_on_lidcheck_body_entered(l)
	set_meta("obj", data)

func _on_insidebox_body_entered(body):
	if(body != self && body.has_meta("obj") && !body is boxlid && body != removeditem && !body is box):
		var obj = body.get_meta("obj")
		if(getcurweight() + obj.weight < maxweight):
			inventory.append(obj)
			body.queue_free()
			updatedata()

func _on_lidcheck_body_entered(body):
	if(body is boxlid && body != lid && lidtime <= 0):
		lid = body
		lid.unlid.connect(unlidded)
		lid.freeze = true
		lid.call_deferred("reparent",self)
		await get_tree().process_frame
		add_collision_exception_with(lid)
		lid.global_position = lidcheck.global_position

func _physics_process(delta):
	super(delta)
	if(global_basis.y.dot(Vector3.UP) < -.4 && lid == null):
		removeitem(null)
	
	if(lidshape.disabled != (lid == null)):
		lidshape.disabled = lid == null
	
	if(lid):
		lid.global_basis = lidcheck.global_basis
	if(lidtime > 0):
		lidtime -= delta

var lidtime : float = 0
func unlidded():
	if(lid):
		lidtime = .4
		#lid.reparent(get_tree().current_scene)
		lid.call_deferred("reparent",get_tree().current_scene)
		await get_tree().process_frame
		remove_collision_exception_with(lid)
		lid.unlid.disconnect(unlidded)
		lid.freeze = false
		lid = null

func getcurweight() -> float:
	var ret : float = 1
	for n : InventoryObject in inventory:
		ret += (n.weight*.5)
	return ret

var removeditem
func removeitem(bod : Player):
	if(inventory.size() > 0):
		var item = inventory[-1]
		var physitem = Library.objs[item.objaddress].instantiate()
		removeditem = physitem
		inventory.erase(item)
		if(bod != null):
			bod.cam.grabobj(physitem)
		physitem.set_meta("obj", item)
		get_tree().current_scene.add_child(physitem)
		physitem.global_position = global_position
		updatedata()
		add_collision_exception_with(removeditem)
		await get_tree().create_timer(.3).timeout
		if(removeditem != null):
			remove_collision_exception_with(removeditem)
			removeditem = null

func updatedata():
	if(data == null):
		data = get_meta("obj").duplicate()
	data.customproperties["inventory"] = serializeinventory()
	data.weight = getcurweight()
	data.customproperties["lid"] = lid != null
	if(lid != null):
		data.icon = load("res://sprites/itemicons/liddedbox.png")
	else:
		data.icon = load("res://sprites/itemicons/box.png")
		
	mass = clamp(data.weight*.75, 1, maxweight)
	set_meta("obj", data)

func info() -> String:
	var ret : String = "Content: \n"
	if(inventory.size()>0):
		for n in inventory:
			ret += n.name + " / " + ("%.1f" % n.weight) + "\n"
	else:
		ret += "empty\n"
	ret += "\nWeight: " + ("%.1f" % getcurweight()) + " / " + ("%.1f" % maxweight)
	return ret

func serializeinventory():
	var ret = []
	for n in inventory:
		ret.append([n.objaddress,n.customproperties])
	return ret

func deserializeinventory(t:Array):
	var ret : Array[InventoryObject] = []
	for n in t:
		var obj = Library.invobjs[n[0]].duplicate()
		obj.customproperties = n[1]
		ret.append(obj)
	return ret
