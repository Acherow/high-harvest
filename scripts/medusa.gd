extends RigidBody3D

@onready var raycast = $Skeleton3D/BoneAttachment3D/head/RayCast3D
@onready var noise = $CanvasLayer/noise

var player : Node3D

var fps : float = 60

@export var patrol : Array[Vector3]
var curpoint : int = 0

func _ready():
	player = get_tree().get_first_node_in_group("player")
	raycast.add_exception(player)
	raycast.add_exception(self)
	noise.modulate.a = 0

var died : bool
func _physics_process(delta):
	if(global_position.distance_to(patrol[curpoint]) < .2):
		curpoint = (curpoint+1) % patrol.size()
	
	apply_central_force((global_position.direction_to(patrol[curpoint])).normalized() * 600)
	#global_basis = lerp(global_basis,global_basis.looking_at((patrol[curpoint]-global_position)/2),delta * 10)
	#move_and_slide()
	var targetbasis = global_basis.looking_at(linear_velocity,Vector3.UP,false)
	apply_torque(Library.calc_angular_velocity(global_basis,targetbasis)*10)
	#return
	raycast.target_position = raycast.to_local(player.global_position) + Vector3.UP
	if(seen() && !died):
		noise.modulate.a = .5-(fps/40)
		#noise.texture.noise.seed = randi_range(0,4)
		fps = clamp(fps,2,40)
		fps -= delta * 20
		if(fps <= 2):
			player.ragdoll(100)
			died = true
	else:
		noise.modulate.a = lerp(noise.modulate.a, 0.0, delta*10)
		fps = 60
	
	fps = clamp(fps, 2,60)
	Engine.max_fps = fps

func seen() -> bool:
	return InfoChecker.visibletoplayer(global_position+Vector3.UP) && !raycast.is_colliding()
