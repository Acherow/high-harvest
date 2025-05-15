extends RigidBody3D

@onready var wheel_bl = $wheelbl
@onready var wheel_fl = $wheelfl
@onready var wheel_fr = $wheelfr
@onready var wheel_br = $wheelbr

@onready var bl_tire_cast = $"bl tire cast"
@onready var fl_tire_cast = $"fl tire cast"
@onready var br_tire_cast = $"br tire cast"
@onready var fr_tire_cast = $"fr tire cast"

@onready var leftseat = $leftseat
@onready var fllight = $"front left light"
@onready var frlight = $"front right light"

@onready var loadarea : Area3D = $loadarea
@onready var run : AudioStreamPlayer3D = $run

var accelinput : float

var lightson : bool = false

var properties : Dictionary

func _ready() -> void:
	await get_tree().process_frame
	if(has_meta("customproperties")):
		properties = get_meta("customproperties").duplicate()
		#print(properties)
	if(properties.has("lights")):
		lightson = properties["lights"]
		fllight.visible = lightson
		frlight.visible = lightson
	if(properties.has("seated") && properties["seated"]):
		#print("bwop")
		leftseat.grabtrigger(get_tree().get_first_node_in_group("player"))
	properties["seated"] = false
	set_meta("customproperties", properties)

func _input(event):
	if(leftseat.seated):
		if(event.is_action_pressed("rightclick")):
			lightson = !lightson
			fllight.visible = lightson
			frlight.visible = lightson

func _physics_process(delta):
	for n in loadobjs:
		#print(n)
		n.apply_force(linear_velocity*2)
	
	if(leftseat.seated):
		accelinput = Input.get_axis("ui_down", "ui_up")
		run.volume_db = lerp(run.volume_db, (abs(accelinput) * 15)-15,delta)
		if(!run.playing):
			run.play()
		var steerinput = Input.get_axis("ui_left", "ui_right")
		if(steerinput < -0.1):
			fl_tire_cast.rotation_degrees.y = 25
			fr_tire_cast.rotation_degrees.y = 25
			wheel_fl.rotation_degrees.y = 25
			wheel_fr.rotation_degrees.y = 26
		elif(steerinput > 0.1):
			fl_tire_cast.rotation_degrees.y = -25
			fr_tire_cast.rotation_degrees.y = -25
			wheel_fl.rotation_degrees.y = -25
			wheel_fr.rotation_degrees.y = -25
		else:
			fl_tire_cast.rotation_degrees.y = 0
			fr_tire_cast.rotation_degrees.y = 0
			wheel_fl.rotation_degrees.y = 0
			wheel_fr.rotation_degrees.y = 0
	else:
		accelinput = 0
		if(run.playing):
			run.stop()
	
	getsuspension(bl_tire_cast,wheel_bl)
	getsuspension(fl_tire_cast,wheel_fl)
	getsuspension(br_tire_cast,wheel_br)
	getsuspension(fr_tire_cast,wheel_fr)
	
	getsteering(bl_tire_cast,wheel_bl,delta)
	getsteering(fl_tire_cast,wheel_fl,delta)
	getsteering(br_tire_cast,wheel_br,delta)
	getsteering(fr_tire_cast,wheel_fr,delta)
	
	getacceleration(fl_tire_cast)
	getacceleration(fr_tire_cast)
	#getacceleration(br_tire_cast)
	#getacceleration(bl_tire_cast)
	
	if(Input.is_action_pressed("shift")):
		brake(fl_tire_cast,delta)
		brake(fr_tire_cast,delta)

func getsuspension(cast : RayCast3D, wheel):
	if(cast.is_colliding()):
		var dir : Vector3 = cast.global_basis.y
		var tirevel = get_point_velocity(cast.global_position)
		wheel.global_position = cast.get_collision_point() - (dir*.6)
		
		var distance = cast.global_position.distance_to(cast.get_collision_point())
		var offset = clamp(1-distance,0,100)
		
		var vel = dir.dot(tirevel)
		
		var force : float = (-offset * 45000) - (vel * 3000)
		dir.x = 0 if abs(dir.x)<.01 else dir.x
		dir.z = 0 if abs(dir.z)<.01 else dir.z
		apply_force(dir * force, (cast.global_position - global_position))
	else:
		wheel.global_position = cast.global_position

func getsteering(cast : RayCast3D, wheel, delta):
	if(cast.is_colliding()):
		var dir = cast.global_basis.x
		var tirevel = get_point_velocity(cast.global_position)
		var vel = dir.dot(tirevel)
		
		var change = -vel * .6
		
		var accel = change / delta
		
		apply_force(dir * 20 * accel, (cast.global_position - global_position))
		#apply_central_force(dir * 5 * accel)

func getacceleration(cast : RayCast3D):
	if(cast.is_colliding()):
		var dir = cast.global_basis.z
		if(abs(accelinput) > 0.1):
			#var carspeed = global_basis.z.dot(linear_velocity)
			#var normspeed = clamp(abs(carspeed), 0,1)
			#var torque = clamp(normspeed,0.5, 1) * accelinput
			apply_force(dir * accelinput * 50000, (cast.global_position - global_position))
			#apply_central_force(dir*torque*1000)

func brake(cast : RayCast3D, delta):
	if(cast.is_colliding()):
		var dir = -cast.global_basis.z
		var tirevel = get_point_velocity(cast.global_position)
		var vel = dir.dot(tirevel)
		
		var change = -vel * 1
		
		var accel = change / delta
		
		apply_force(dir * 10 * accel, (cast.global_position - global_position))

func get_point_velocity (point :Vector3)->Vector3:
	return linear_velocity + angular_velocity.cross(point - global_transform.origin)


var loadobjs : Array
func _on_load_body_entered(body):
	if body != self && body is RigidBody3D:
		loadobjs.append(body)

func _on_load_body_exited(body):
	loadobjs.erase(body)
