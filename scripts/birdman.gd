extends CharacterBody3D

var movespeed: float = 500
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var cast: RayCast3D = $RayCast3D

var player

var state : String = "arrival"
var cowardice : float = 0

var spawnpoint : Vector3

func _ready() -> void:
	spawnpoint = global_position
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	match state:
		"arrival":
			anim.speed_scale = 1
			if(!cast.is_colliding()):
				global_basis = global_basis.slerp(global_basis.looking_at(global_position.direction_to(player.global_position),Vector3.UP,true),.1)
				velocity = global_basis.z * movespeed * delta
				anim.play("walk")
			else:
				anim.play("observe")
			if(InfoChecker.visibletoplayer(global_position)):
				state = "observe"
		"observe":
			anim.speed_scale = 1
			if(InfoChecker.visibletoplayer(global_position)):
				cowardice += delta
				if(cowardice > 6):
					state = "runaway"
			elif(cowardice < 6):
				state = "arrival"
			anim.play("idle")
			global_basis = global_basis.slerp(global_basis.looking_at(global_position.direction_to(player.global_position),Vector3.UP,true),.1)
		"runaway":
			global_basis = global_basis.slerp(global_basis.looking_at(global_position.direction_to(spawnpoint),Vector3.UP,true),.1)
			velocity = global_basis.z * movespeed * delta * 4
			anim.play("walk")
			anim.speed_scale = 4
			if(global_position.distance_to(spawnpoint) < 1):
				queue_free()
	
	move_and_slide()
