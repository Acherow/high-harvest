extends Node3D
class_name crop

@export var maxgrowtime : float = 10
@export var dryrate : float = 1
@export var stages : Array[Material]
@export var stalk : MeshInstance3D
@export var dropaddress : String
@export var seedaddress : String

@onready var coveredhole = $coveredhole

var wetstages : Array = [
	preload("res://models/textures/dirt/dirtdry.tres"),
	preload("res://models/textures/dirt/dirtdrying.tres"),
	preload("res://models/textures/dirt/dirtwet.tres")
]

var curstage : int = 0
var curtime : float = 0
var curwetness : float = 15

func _process(delta):
	if(curwetness >= 0):
		curwetness -= delta * dryrate * .1
	
	if(curwetness > 20):
		coveredhole.set_surface_override_material(0, wetstages[2])
	elif(curwetness > 10):
		coveredhole.set_surface_override_material(0, wetstages[1])
	else:
		coveredhole.set_surface_override_material(0, wetstages[0])
	
	if(curtime < maxgrowtime && curwetness > 0):
		curtime += delta
		if(curtime > (maxgrowtime/stages.size()) * (curstage+1) && curstage < stages.size()):
			curstage += 1
			stalk.mesh.material = stages[curstage-1]

func water():
	curwetness = clamp(curwetness+3, 0, 30)

func uproot():
	if(curtime >= maxgrowtime):
		var c : RigidBody3D = Library.objs[dropaddress].instantiate()
		get_tree().current_scene.add_child(c)
		c.global_position = global_position + (Vector3.UP * .2)
		c.apply_central_impulse(Vector3(randf_range(-2,2),1,randf_range(-2,2)))
		if(seedaddress != ""):
			for n in randi_range(-1,2):
				var b = Library.objs[seedaddress].instantiate()
				get_tree().current_scene.add_child(b)
				b.global_position = global_position
				b.apply_central_impulse(Vector3(randf_range(-2,2),1,randf_range(-2,2)))
	elif (seedaddress != ""):
		var c = Library.objs[seedaddress].instantiate()
		get_tree().current_scene.add_child(c)
		c.global_position = global_position
	queue_free()
