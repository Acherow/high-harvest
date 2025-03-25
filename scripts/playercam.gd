extends Camera3D
class_name PlayerCam

@onready var body : Player = get_parent()
@onready var cast : RayCast3D = $RayCast3D
@onready var grabpos = $grabpos
@onready var heldpos = $heldpos
@onready var hoveredinfobox = $CanvasLayer/grabbedinfobox
@onready var hoveredinfolabel = $CanvasLayer/grabbedinfobox/MarginContainer/infolabel
@onready var heldinfobox = $CanvasLayer/heldinfobox
@onready var heldinfolabel = $CanvasLayer/heldinfobox/MarginContainer/infolabel

var CameraRotation = Vector2.ZERO
var MouseSensitivity = .002
var MouseEvent

var grabbeddistance : float = 2
var rotating : bool = false
var grabbed : RigidBody3D = null
var held = null
@onready var inventory : Inventory = $CanvasLayer/inventory

var camfrozen : bool = false

func _ready():
	cast.add_exception(body)
	forceupdaterotation()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	inventory.spawn.connect(dropobj)

func _input(event):
	if !camfrozen && event is InputEventMouseMotion:
		MouseEvent = event.relative * MouseSensitivity
		if(!rotating):
			CameraLook(MouseEvent)
	if(body.ragdolled):
		if(grabbed != null):
			letgoofgrabbed()
		if(held != null):
			letgoofheld()
		return
	
	#if(event.is_action_pressed("ui_home")):
		#print(Savedata.gamedata["stocks"])
		#print(Savedata.gamedata["daysales"])
	#if(event.is_action_pressed("ui_end")):
		#body.get_node("%day manager").passday()
	
	if(event.is_action_pressed("grab") && cast.is_colliding()):
		var obj = cast.get_collider()
		if(obj == null):
			return
		if(obj.has_method("grabtrigger")):
			obj.grabtrigger(body)
		if(obj is pickupproxy):
			if(obj.source.has_method("grabtrigger")):
				obj.source.grabtrigger(body)
		if(obj is PhysicsBody3D):
			grabobj(obj)
	if event.is_action_released("grab"):
		if(is_instance_valid(grabbed) && grabbed.has_method("endgrabtrigger")):
			grabbed.endgrabtrigger(body)
		letgoofgrabbed()
	if(event.is_action_pressed("hold")):
		holdobj()
		if(held != null && !held.is_queued_for_deletion()):
			var obj = held
			if(obj.has_method("holdtrigger")):
				obj.holdtrigger(body)
			if(obj is pickupproxy):
				if(obj.source.has_method("holdtrigger")):
					obj.source.holdtrigger(body)
	if(event.is_action_pressed("store")):
		if(grabbed != null):
			var intent = grabbed
			if(grabbed is pickupproxy):
				intent = grabbed.source
			if(intent.has_meta("obj")):
				var objweight = intent.get_meta("obj").weight
				if(inventory.currentweight + objweight <= inventory.maxweight):
					if(intent.has_method("updatedata")):
						intent.updatedata()
					
					inventory.invlist.append(intent.get_meta("obj"))
					inventory.UpdateList()
					intent.queue_free()
					grabbed = null
		elif (held != null && (!held.has_method("candrop") || held.candrop() == true)):
			if(held.has_meta("obj")):
				var objweight = held.get_meta("obj").weight
				if(inventory.currentweight + objweight <= inventory.maxweight):
					if(held.has_method("updatedata")):
						held.updatedata()
					inventory.invlist.append(held.get_meta("obj"))
					inventory.UpdateList()
					held.queue_free()
					held = null
	if(event.is_action_pressed("inventory")):
		if(!inventory.visible):
			inventory.showInv()
			body.frozen = true
			camfrozen = true
		else:
			inventory.hideInv()
			camfrozen = false
	if(event.is_action_pressed("leftclick")):
		if(held != null && held.has_method("trigger") && !camfrozen && !inventory.visible):
			held.trigger(self)
		elif(grabbed && is_instance_valid(grabbed)):
			grabbed.apply_impulse(-global_basis.z * 20 * grabbed.mass)
			letgoofgrabbed()
	if event.is_action_pressed("rightclick"):
		if(grabbed && is_instance_valid(grabbed)):
			rotating = true
		elif(held != null && held.has_method("sectrigger") && !camfrozen && !inventory.visible):
			held.sectrigger(self)
	if event.is_action_released("rightclick"):
		rotating = false
	if event.is_action_released("MWU"):
		grabbeddistance += .1
		grabbeddistance = clamp(grabbeddistance, 1,3)
	if event.is_action_released("MWD"):
		grabbeddistance -= .1
		grabbeddistance = clamp(grabbeddistance, 1,3)

func holdobj():
	var intent = grabbed
	if(grabbed != null && is_instance_valid(grabbed) && grabbed is pickupproxy):
		intent = grabbed.source
	
	if(intent != null && !intent.is_in_group("heavy") && held == null):
		heldinfobox.visible = true
		held = intent
		held.add_to_group("held")
		body.add_collision_exception_with(held)
		grabbed = null
		held.reparent(heldpos)
		if(held.has_method("hold")):
			held.hold(self)
		held.position = Vector3.ZERO
		held.rotation = Vector3.ZERO
		held.freeze = true
		for n in held.find_children("*", "CollisionShape3D", true, false):
			if(n.get_parent() is RigidBody3D && !n.get_parent().is_in_group("disableimmune")):
				n.disabled = true
	elif(held != null && (!held.has_method("candrop") || held.candrop() == true)):
		letgoofheld()

func grabobj(obj):
	if(obj.is_in_group("pickup") && obj is RigidBody3D):
		if(obj.is_inside_tree()):
			grabpos.global_rotation = obj.global_rotation
		grabbed = obj
		#body.add_collision_exception_with(grabbed)
		if(obj.has_method("grabbed")):
			obj.grabbed(self)

func letgoofgrabbed():
	if(grabbed != null):
		grabpos.rotation = Vector3.ZERO
		rotating = false
		if(is_instance_valid(grabbed) && grabbed is RigidBody3D):
			grabbed.sleeping = false
		if(grabbed.has_method("grabbed")):
			grabbed.grabbed(null)
		#body.remove_collision_exception_with(grabbed)
		grabbed = null

func letgoofheld():
	if(held == null):
		return #GO FUCK YORUERBYUBDFUI
	
	held.remove_from_group("held")
	body.remove_collision_exception_with(held)
	held.reparent(get_tree().current_scene)
	if(cast.is_colliding()):
		held.global_position = cast.get_collision_point() + (cast.global_basis.z*.2)
	else:
		held.global_position = global_position - (global_basis.z*2)
	if(held.has_method("hold")):
		held.hold(null)
	held.freeze = false
	for n in held.find_children("*", "CollisionShape3D", true, false):
		if(n.get_parent() is RigidBody3D):
			n.disabled = false
	held = null

func dropobj(ob : InventoryObject):
	var o = Library.objs[ob.objaddress].instantiate()
	o.set_meta("obj", ob)
	get_tree().current_scene.add_child(o)
	o.global_position = global_position - global_basis.z

func _physics_process(delta):
	grabpos.position.z = -grabbeddistance
	if(grabbed != null):
		if(global_position.distance_to(grabbed.global_position) > 7):
			letgoofgrabbed()
			return
		
		var force = ((grabpos.global_position - grabbed.global_position) * 100) - (grabbed.linear_velocity * 10)
		#var strength = clamp(,.1,1)
		grabbed.apply_central_force(force)
		var torque = Library.calc_angular_velocity(grabbed.global_basis,grabpos.global_basis)
		grabbed.apply_torque(torque * grabbed.mass * 10)
		if(grabbed && rotating):
			grabpos.rotate(basis.y,MouseEvent.x * clamp(2-(grabbed.mass*.1), 0.01,1))
			grabpos.rotate(basis.x,MouseEvent.y * clamp(2-(grabbed.mass*.1), 0.01,1))

func _process(delta):
	if(is_instance_valid(held) && held.has_method("info")):
		heldinfobox.visible = true
		heldinfolabel.text = held.info()
	else:
		heldinfobox.visible = false
	
	var intersc = getaimcollision()
	if(intersc.has("collider") && intersc.collider.has_method("info") && intersc.collider.info() != null):
		hoveredinfobox.visible = true
		hoveredinfolabel.text = intersc.collider.info()
	else:
		hoveredinfobox.visible = false
	
	var vel = body.velocity * body.global_transform.basis
	vel = Vector3(clamp(vel.y-vel.z if abs(vel.y-vel.z) > 2 else 0, -.1, .1), 0, clamp(vel.x if abs(vel.x) > 4 else 0, -.1, .1))

func getplayeraim():
	var origin = global_position
	var end = origin + -global_basis.z * 100
	
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.exclude = [body]
	var intersection = get_world_3d().direct_space_state.intersect_ray(query)
	if not intersection.is_empty():
		return intersection.position
	else:
		return end

func getaimcollision():
	var origin = global_position
	var end = origin + -global_basis.z * 100
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.exclude = [body]
	var intersection = get_world_3d().direct_space_state.intersect_ray(query)
	intersection
	return intersection

func forceupdaterotation():
	var rot = body.transform.basis.get_euler()
	CameraLook(Vector2(-rot.y, -rot.x))

func CameraLook(Movement: Vector2):
	CameraRotation += Movement
	CameraRotation.y = clamp(CameraRotation.y, -1.5, 1.6)
	
	if(!body.ragdolled):
		body.transform.basis = Basis()
		body.rotate_object_local(Vector3(0,1,0), -CameraRotation.x)
	transform.basis = Basis()
	rotate_object_local(Vector3(1,0,0), -CameraRotation.y)
