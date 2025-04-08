extends RigidBody3D
class_name rat

@export var movespeed : float = 6
@onready var head = $head

var tgt
var curdir
var eaten

var path : Array

func _ready():
	tgt = getclosestfood()

func _physics_process(delta):
	if(eaten):
		tgt = getclosesthole()
		if(path == null || path.is_empty()):
			path = get_tree().get_first_node_in_group("ratvigation").getpath(global_position+linear_velocity,tgt.global_position)
	if(tgt != null):
		if(path == null || path.is_empty()):
			curdir = global_position.direction_to(tgt.global_position).normalized()
		else:
			curdir = global_position.direction_to(path[0]).normalized()
			if(global_position.distance_to(path[0]) < .5):
				path.remove_at(0)
		if(!eaten && tgt.global_position.distance_to(global_position) < .5):
			eaten = true
			tgt.queue_free()
	else:
		eaten = true
	if(curdir != Vector3.ZERO):# && global_basis.y.dot(Vector3.UP) > 0.1):
		linear_damp = 0 if linear_velocity.length() < .1 else 1
		sleeping = false
		head.apply_force(curdir * movespeed, (basis.z*.5))
		#apply_force(curdir * movespeed, (basis.z*.2))

func getclosestfood():
	var food
	for n in get_tree().get_nodes_in_group("food"):
		if((food == null || global_position.distance_to(food.global_position) > global_position.distance_to(n.global_position))):
			food = n
	return food

func getclosesthole():
	var hole
	for n in get_tree().get_nodes_in_group("mousehole"):
		if((hole == null || global_position.distance_to(hole.global_position) > global_position.distance_to(n.global_position))):
			hole = n
	return hole
