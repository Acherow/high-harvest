extends Node
var nodes : Array = []

func _ready():
	nodes = get_children()
	#nodes = get_children()

func getpath(startpoint:Vector3,endpoint:Vector3) -> Array:
	var startnode : AStarNode = null
	var endnode : AStarNode = null
	for n in nodes:
		if(startnode == null || startnode.global_position.distance_to(startpoint) > n.global_position.distance_to(startpoint)):
			startnode = n
		if(endnode == null || endnode.global_position.distance_to(endpoint) > n.global_position.distance_to(endpoint)):
			endnode = n
	var open : Array
	var closed : Array
	var hcosts : Dictionary
	var gcosts : Dictionary
	var parents : Dictionary
	
	for n in nodes:
		#gcosts[n] = n.global_position.distance_to(startnode.global_position)
		gcosts[n] = 0
		#hcosts[n] = n.global_position.distance_to(endnode.global_position)
		hcosts[n] = 0
	
	if(startnode == null || startpoint.distance_to(endpoint) < startpoint.distance_to(startnode.global_position)):
		return [startpoint,endpoint]
	
	open.append(startnode)
	while !open.is_empty():
		var cur : AStarNode = open[0]
		for n in open:
			var curf = hcosts[cur] + gcosts[cur]
			var nf = hcosts[n] + gcosts[n]
			#print((nf < curf || (nf == curf && hcosts[n] < hcosts[cur])))
			if((nf < curf || (nf == curf && hcosts[n] < hcosts[cur]))):#&&n.size >= size):
				cur = n
		open.erase(cur)
		closed.append(cur)
		if cur == endnode:
			var list = []
			var retrace = cur
			list.append(endpoint)
			while retrace != startnode && retrace != null:
				list.append(retrace.global_position)
				retrace = parents[retrace]
			list.append(startnode.global_position)
			#list.append(startpoint)
			list.reverse()
			return list
		
		for n in cur.neighbors:
			if(closed.has(n)):
				continue
			var movcost = gcosts[cur] + cur.global_position.distance_to(n.global_position)
			if(movcost < gcosts[n] || !open.has(n)):
				gcosts[n] = movcost
				hcosts[n] = n.global_position.distance_to(endnode.global_position)
				parents[n] = cur
				if(!open.has(n)):
					open.append(n)
	print("shrug")
	return [startpoint,endpoint]
