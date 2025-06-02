extends CharacterBody3D

@onready var viewbox : Node3D = $viewbox
@onready var faceanim = $faceanim
@onready var poses = $poses
@onready var casts = [
	$viewbox/RayCast3D,
	$viewbox/RayCast3D2,
	$viewbox/RayCast3D3,
	$viewbox/RayCast3D4
]
@onready var audio = $audio

var player : Node3D
var nav : Navigation

var path : Array

func _ready():
	nav = get_tree().get_first_node_in_group("angelnav")
	player = get_tree().get_first_node_in_group("player")
	for n in casts:
		n.add_exception(player)

func _process(delta):
	viewbox.global_basis = viewbox.global_basis.looking_at(global_position.direction_to(player.global_position))
	for n : RayCast3D in casts:
		n.target_position = n.to_local(player.global_position) + Vector3.UP


var visibl
func _physics_process(delta):
	#return
	if(visibl != seen()):
		visibl = seen()
		if(visibl):
			poses.play(["pose1"].pick_random())
		faceanim.play("faceoff")
		
	if(!visibl && !path.is_empty() && global_position.distance_to(player.global_position) < 20):
		#axis_lock_linear_x = false
		#axis_lock_linear_z = false
		
		if(global_position.distance_to(path[0]) < .2):
			path.remove_at(0)
		else:
			if(path.is_empty()):
				return
			if(!audio.playing):
				audio.play()
			velocity = (global_position.direction_to(path[0])).normalized() * 15
			velocity.y = 0
			global_basis = global_basis.looking_at((velocity + getprojected(player.global_position-global_position, Vector3.UP))/2)
			move_and_slide()
		#global_basis = global_basis.looking_at(getprojected(player.global_position-global_position, Vector3.UP))
	else:
		#axis_lock_linear_x = true
		#axis_lock_linear_z = true
		velocity = Vector3.ZERO
		#audio.stop()
	
	if(!visibl && global_position.distance_to(player.global_position) < 1):
		player.ragdoll(1)
	

func seen() -> bool:
	return InfoChecker.visibletoplayer(global_position) && \
	(!casts[0].is_colliding()||!casts[1].is_colliding()||!casts[2].is_colliding()||!casts[3].is_colliding())

func findpath():
	path = nav.getpath(global_position, player.global_position)

func getprojected(pos : Vector3, normal : Vector3) -> Vector3:
	normal = normal.normalized()
	var projection = (pos.dot(normal)/normal.dot(normal)) * normal
	return pos - projection
