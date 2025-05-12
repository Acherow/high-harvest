extends Node

func serializeall():
	var list : Array
	var player : Player = get_tree().get_first_node_in_group("player")
	var plinventory = []
	var playerhand = []
	var playergrabbed = []
	var excludehand = null
	var excludegrabbed = null
	for n : InventoryObject in player.cam.inventory.invlist:
		plinventory.append([n.objaddress, n.customproperties])
	if player.cam.held != null && player.cam.held.has_meta("obj"):
		excludehand = player.cam.held
		var data : InventoryObject = player.cam.held.get_meta("obj")
		playerhand = [data.objaddress,data.customproperties]
	if(player.cam.grabbed != null):
		var ob = player.cam.grabbed
		if(ob is pickupproxy):
			ob = ob.source
		if(ob.has_meta("obj")):
			excludegrabbed = ob
			var data : InventoryObject = ob.get_meta("obj")
			playergrabbed = ["obj",data.objaddress,data.customproperties]
		elif(ob.has_meta("objaddress")):
			excludegrabbed = ob
			playergrabbed = ["heavy",ob.get_meta("objaddress"),ob.get_meta("customproperties",0)]
	#var plscene = Savedata.gamedata["player"][0]
	Savedata.gamedata["player"] = [player.global_position,player.global_rotation,player.energy,player.hunger,plinventory, playerhand,playergrabbed]
	#list.append(["player", player.global_position, player.global_rotation, player.energy,player.hunger,plinventory, playerhand,playergrabbed])
	
	var allobjs = get_tree().get_nodes_in_group("pickup")
	if(excludehand != null):
		allobjs.erase(excludehand)
	if(excludegrabbed != null):
		allobjs.erase(excludegrabbed)
	for n in allobjs:
		if(n.has_meta("obj")):
			var data : InventoryObject = n.get_meta("obj")
			if(data.objaddress == ""):
				return
			list.append(["pickup", n.global_position, n.global_rotation, data.objaddress, data.customproperties])
	
	var serquests = get_tree().get_nodes_in_group("serialize")
	for n in serquests:
		if(n is crop):
			list.append(["crop", n.global_position, n.global_rotation, n.seedaddress, n.curtime])
		if(n is crophole):
			list.append(["crop", n.global_position, n.global_rotation, "crophole"])
		if(n.has_meta("objaddress")):
			var props = {}
			if(n.has_meta("customproperties")):
				props = n.get_meta("customproperties")
			list.append(["other", n.get_meta("objaddress"),n.global_position,n.global_rotation,props])
	Savedata.gamedata["objects%s"%Savedata.gamedata["playerscene"]] = list
	#Savedata.save_data()

func deserializeall():
	#Savedata.delete_data()
	if(Savedata.gamedata.is_empty()):
		Savedata.load_data()
	get_tree().current_scene.get_node("%day manager").timeofday = Savedata.gamedata["timeofday"]
	
	var plinfo = Savedata.gamedata["player"]
	var player : Player = get_tree().get_first_node_in_group("player")
	var plinventory = []
	for i in plinfo[4]:
		var data : InventoryObject = Library.invobjs[i[0]].duplicate()
		data.customproperties = i[1]
		plinventory.append(data)
	player.global_position = plinfo[0]
	player.global_rotation = plinfo[1]
	player.energy = plinfo[2]
	player.hunger = plinfo[3]
	player.cam.forceupdaterotation()
	player.cam.inventory.invlist = plinventory
	if(!plinfo[5].is_empty()):
		var obj = Library.objs[plinfo[5][0]].instantiate()
		var data = obj.get_meta("obj").duplicate()
		data.customproperties = plinfo[5][1]
		obj.set_meta("obj", data)
		get_tree().current_scene.add_child(obj)
		player.cam.grabbed = obj
		player.cam.holdobj()
	if(!plinfo[6].is_empty()):
		if(plinfo[6][0] == "obj"):
			var obj = Library.objs[plinfo[6][1]].instantiate()
			var data = obj.get_meta("obj").duplicate()
			data.customproperties = plinfo[6][2]
			obj.set_meta("obj", data)
			get_tree().current_scene.add_child(obj)
			obj.global_position = player.global_position + -player.global_basis.z
			player.cam.grabobj(obj)
		elif(plinfo[6][0] == "heavy"):
			var obj = Library.others[plinfo[6][1]].instantiate()
			#var data = obj.get_meta("obj").duplicate()
			#data.customproperties = plinfo[6][2]
			#obj.set_meta("obj", data)
			get_tree().current_scene.add_child(obj)
			obj.global_position = player.global_position + -player.global_basis.z + (Vector3.UP * 1)
			player.cam.grabobj(obj)
	
	if(!Savedata.gamedata.has("objects%s"%Savedata.gamedata["playerscene"])):
		return
	
	var list = Savedata.gamedata["objects%s"%Savedata.gamedata["playerscene"]].duplicate()
	for n in list:
		match(n[0]):
			"pickup":
				var obj = Library.objs[n[3]].instantiate()
				var data = obj.get_meta("obj").duplicate()
				data.customproperties = n[4]
				obj.set_meta("obj", data)
				get_tree().current_scene.add_child(obj)
				obj.global_position = n[1]
				obj.global_rotation = n[2]
			"crop":
				if(n[3] == ""):
					n[3] = "pumpkinseed"
				var obj = Library.crops[n[3]].instantiate()
				get_tree().current_scene.add_child(obj)
				if(obj is crop):
					obj.curtime = n[4]
				obj.global_position = n[1]
				obj.global_rotation = n[2]
			"other":
				var obj :Node3D = Library.others[n[1]].instantiate()
				get_tree().current_scene.add_child(obj)
				obj.global_position = n[2]
				obj.global_rotation = n[3]
				if(n.size() > 4 && !n[4].is_empty()):
					obj.set_meta("customproperties", n[4])
