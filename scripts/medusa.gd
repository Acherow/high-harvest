extends Node3D

@onready var raycast = $Skeleton3D/BoneAttachment3D/head/RayCast3D
@onready var noise = $CanvasLayer/noise

var player : Node3D

var fps : float = 60

func _ready():
	player = get_tree().get_first_node_in_group("player")
	raycast.add_exception(player)
	raycast.add_exception(self)
	noise.modulate.a = 0

func _physics_process(delta):
	return
	raycast.target_position = raycast.to_local(player.global_position) + Vector3.UP
	if(seen()):
		noise.modulate.a = .5-(fps/40)
		#noise.texture.noise.seed = randi_range(0,4)
		fps = clamp(fps,2,40)
		fps -= delta * 20
		if(fps <= 2):
			player.ragdoll(100)
	else:
		noise.modulate.a = lerp(noise.modulate.a, 0.0, delta*10)
		fps = 60
	
	fps = clamp(fps, 2,60)
	Engine.max_fps = fps

func seen() -> bool:
	return InfoChecker.visibletoplayer(global_position+Vector3.UP) && !raycast.is_colliding()
