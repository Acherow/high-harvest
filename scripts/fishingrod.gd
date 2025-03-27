extends basepickup

@onready var rod: MeshInstance3D = $rod
@onready var bobber: RigidBody3D = $rod/bobber
@onready var linerender: MeshInstance3D = $linerender
@onready var rendpoint: Node3D = $rod/rendpoint
@onready var throwcooldown: Timer = $throwcooldown
@onready var fishtime: Timer = $fishtime
@onready var anim: AnimationPlayer = $rod/bobber/AnimationPlayer

@export var waittime : Vector2
@export var escapetime : Vector2

var throwing : bool = false

var throwlength : float = 0

var resetting : bool = false

var castout : bool = false

var catch : String

var pl : PlayerCam

func _ready() -> void:
	super()
	add_collision_exception_with(bobber)

func trigger(bod):
	if(throwing || resetting || castout):
		return
	throwing = true
	pl = bod

func _physics_process(delta: float) -> void:
	bobber.get_node("CollisionShape3D").disabled = castout
	if(catch != ""):
		anim.play("caught")
	else:
		anim.play("RESET")
	
	if(castout && throwcooldown.is_stopped()):
		if(Input.is_action_pressed("leftclick")):
			if(!fishtime.is_stopped()):
				fishtime.start()
			if(bobber.linear_velocity.length() < .2):
				bobber.linear_velocity = Vector3.UP
			bobber.apply_force((global_position - bobber.global_position).normalized() * (2.6 if catch != "" else 3))
		var mypos = global_position
		mypos.y = 0
		var bobpos = bobber.global_position
		bobpos.y = 0
		if(mypos.distance_to(bobpos) < 1.5):
			reset()
	
	linerender.SetPoints([rendpoint.global_position,bobber.global_position])
	super(delta)
	if(throwing):
		if(!Input.is_action_pressed("leftclick")):
			throwing = false
			resetting = false
			cast()
		throwlength = clamp(throwlength+delta, 0,1)
	else:
		if(!resetting && throwlength != 0):
			throwlength = clamp(throwlength-(delta*40), -2,1)
		else:
			throwlength = clamp(throwlength+(delta*3), -2,0)
		if(throwlength < -.9):
			resetting = true
		elif throwlength == 0:
			resetting = false
	rod.rotation_degrees.x = lerp(0,25,throwlength/1)

func cast():
	throwcooldown.start()
	castout = true
	bobber.reparent(get_tree().current_scene)
	bobber.freeze = false
	bobber.sleeping = false
	bobber.global_basis = Basis()
	bobber.apply_impulse(global_basis.z * -3 * throwlength)

func reset():
	if(catch != ""):
		var objweight = Library.invobjs[catch].weight
		if(pl.inventory.currentweight + objweight <= pl.inventory.maxweight):
			pl.inventory.invlist.append(Library.invobjs[catch])
			pl.inventory.UpdateList()
		catch = ""
	bobber.reparent(rod)
	bobber.freeze = true
	await get_tree().process_frame
	castout = false
	bobber.position = Vector3(0,1.05,-.1)
	bobber.basis = Basis()

func _on_bobber_body_entered(body: Node) -> void:
	if(body.is_in_group("water")):
		fishtime.start(randi_range(waittime.x,waittime.y))

func _on_fishtime_timeout() -> void:
	if(catch != ""):
		catch = ""
		fishtime.start(randi_range(waittime.x,waittime.y))
	else:
		var chances = []
		for n in Library.fish:
			for b in Library.fish[n]:
				chances.append(n)
		catch = chances.pick_random()
		fishtime.start(randi_range(escapetime.x,escapetime.y))
