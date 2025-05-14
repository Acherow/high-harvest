extends Node3D

@onready var raycast = $skeleton/BoneAttachment3D/head/RayCast3D

var player : Node3D

func _ready():
	player = get_tree().get_first_node_in_group("player")
	raycast.add_exception(player)

func _physics_process(delta):
	raycast.target_position = raycast.to_local(player.global_position) + Vector3.UP

func seen() -> bool:
	return InfoChecker.visibletoplayer(global_position) && !raycast.is_colliding()
