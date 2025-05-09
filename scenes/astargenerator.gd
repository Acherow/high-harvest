@tool
extends Node3D

@export var size : Vector2
@export var generate : bool = false
@export var delete : bool = false
@export var commit : bool = false

var nodes : Array[Array]

@export var output : Array

func _process(delta):
	if(generate):
		generate = false
		gen()
	if(delete):
		delete = false
		for n in get_children():
			n.queue_free()
	if(commit):
		commit = false
		output = []
		for x in nodes:
			for y in x:
				if(y != null):
					output.append(y)
		print(output)
		#$"../heaven".nodes = ar

func gen():
	nodes.resize(size.x)
	var shape = BoxShape3D.new()
	shape.size = Vector3.ONE
	var params = PhysicsShapeQueryParameters3D.new()
	params.shape = shape
	var world = get_world_3d().direct_space_state
	var trans = Transform3D()
	trans.basis = Basis()
	for x in nodes.size():
		nodes[x].resize(size.y)
		#nodes[x].fill(AStarNode.new())
		for y in nodes[x].size():
			trans.origin = global_position + Vector3(x,0,y)
			params.transform = trans
			#params.
			var results = world.intersect_shape(params)
			if(results.is_empty()):
				nodes[x][y] = AStarNode.new()
				add_child(nodes[x][y])
				nodes[x][y].position = Vector3(x,0,y)
				nodes[x][y].owner = get_tree().edited_scene_root
	for x in nodes.size():
		for y in nodes[x].size():
			if(nodes[x][y] != null):
				nodes[x][y].neighbors.clear()
				if(y >= 1 && nodes[x][y-1] != null):
					nodes[x][y].neighbors.append(nodes[x][y-1])
				if(y < size.y&& nodes[x][y+1] != null):
					nodes[x][y].neighbors.append(nodes[x][y+1])
				if(x >= 1&& nodes[x-1][y] != null):
					nodes[x][y].neighbors.append(nodes[x-1][y])
				if(x < size.x&& nodes[x+1][y] != null):
					nodes[x][y].neighbors.append(nodes[x+1][y])
	return
	for x in nodes.size():
		for y in nodes[x].size():
			if(nodes[x][y] != null):
				var nod = Marker3D.new()
				add_child(nod)
				nod.position = Vector3(x,0,y)
				nod.owner = get_tree().edited_scene_root
	
	
