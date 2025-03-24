extends Node3D

@onready var flag = $flag
@onready var lid = $lid
@onready var area = $Area3D
@onready var letterspawn : Node3D= $letterspawn
@onready var boxspawn = $boxspawn

var ignore : Array

@export var allquests : Array[Quest]
var curquests : Array[Quest]

func _ready():
	%"day manager".day.connect(spawnflyer)
	for n in Savedata.gamedata["curquests"]:
		var i = allquests[n[0]]
		var q = i.duplicate()
		q.progress = n[1]
		q.index = n[0]
		curquests.append(q)
	#spawnnewspaper()

func _on_timer_timeout():
	if(InfoChecker.visibletoplayer(global_position)):
		return
	var delivery : Array = area.get_overlapping_bodies()
	delivery.erase(lid)
	var usedturn : bool = false
	if(delivery != null && !delivery.is_empty()):
		for n in delivery:
			if(!ignore.has(n) && n is box): #.is_in_group("pickup") && !n.is_in_group("heavy")
				usedturn = true
				spawnletter(n.inventory)
				spawnnewspaper()
				n.queue_free()
			if(!ignore.has(n) && n is storeflyer && !n.buyingselection.is_empty()):
				var totalprice : float = 0
				for i in n.buyingselection:
					totalprice += Library.purchasables[i]
				
				if(Savedata.gamedata["money"] - totalprice >= 0):
					usedturn = true
					Savedata.gamedata["money"] -= totalprice
					var bx : box = Library.objs["box"].instantiate()
					ignore.append(bx)
					var receipt : InventoryObject = Library.invobjs["receipt"].duplicate()
					receipt.customproperties["text"] = "Thank you for your purchase.\nYour new balance is $%s." % Savedata.gamedata["money"]
					bx.inventory.append(receipt)
					for i in n.buyingselection:
						for q in n.buyingselection[i]:
							bx.inventory.append(Library.invobjs[i].duplicate())
					get_tree().current_scene.add_child(bx)
					bx.global_position = boxspawn.global_position
					bx.global_rotation = boxspawn.global_rotation
					n.queue_free()
			elif(n is storeflyer):
				usedturn = true
	if(!usedturn):
		flag.rotation_degrees = Vector3(0,0,90)
		lid.rotation_degrees = Vector3.ZERO
		spawnflyer()

func spawnletter(solditems : Array):
	flag.rotation_degrees = Vector3.ZERO
	var itemamounts : Dictionary
	for n : InventoryObject in solditems:
		var pp = n.name.to_lower()
		if(n.customproperties.has("sellmod")):
			pp = n.customproperties["sellmod"]
		if(!itemamounts.has(pp)):
			itemamounts[pp] = 0
		itemamounts[pp] += 1
	#print(itemamounts)
	var str = "Thank you for your contribution.\n\n\n"
	for n in itemamounts:
		var amt : float = Library.sell(n)
		var erases = []
		for q in curquests:
			for p in itemamounts[n]:
				q.check(n,amt)
			if(q.progress >= q.goal):
				str += q.reward()
				erases.append(q)
				#print(Savedata.gamedata.unlocks)
		for p in erases:
			curquests.erase(p)
		if(Savedata.gamedata.daysales.has(n)):
			Savedata.gamedata.daysales[n] += itemamounts[n]
		for b in itemamounts[n]:
			str += "\n%s : $%.2f" % [n, amt]
	str += "\n\nYour new total balance is: $%.2f\n" % Savedata.gamedata["money"]
	#if(Savedata.gamedata["curdebtgoal"] > 0):
	#	str += "Your current incentive goal is $%.2f\n" % Savedata.gamedata["curdebtgoal"]
	#else:
	#	str += "You have met your current incentive goal and have been rewarded with a small gift of $%.0f. A new incentive goal of $%.0f" % [Library.incentivereward, Library.incentivegoal]
	#	Savedata.gamedata["money"] += Library.incentivereward
	#	Savedata.gamedata["curincentivegoal"] = Library.incentivegoal
	if(!Savedata.gamedata["debtpaid"] && Savedata.gamedata["money"] >= Library.debt):
		Savedata.gamedata["debtpaid"] = true
		Savedata.gamedata["money"] -= Library.debt
		var bx : box = Library.objs["box"].instantiate()
		ignore.append(bx)
		var receipt : InventoryObject = Library.invobjs["receipt"].duplicate()
		receipt.customproperties["text"] = "Your debt is paid. A commemorative plaque has been issued."
		bx.inventory.append(receipt)
		var obj = Library.invobjs["plaque"].duplicate()
		obj.customproperties["timeplayed"] = Savedata.gamedata["playtime"]
		obj.customproperties["moneyearned"] = Savedata.gamedata["totalmoney"]
		bx.inventory.append(obj)
		get_tree().current_scene.add_child(bx)
		bx.global_position = boxspawn.global_position
		bx.global_rotation = boxspawn.global_rotation
	if(!Savedata.gamedata["debtpaid"]):
		str += ("Your total debt is %.2f. " % Library.debt)
	
	var letter : bankstatement = Library.objs["bankstatement"].instantiate()
	get_tree().current_scene.add_child(letter)
	
	letter.text(str)
	letter.global_position = letterspawn.global_position
	letter.global_rotation = letterspawn.global_rotation

func spawnflyer():
	var flyer : storeflyer = Library.objs["storeflyer"].instantiate()
	#ignore.append(flyer)
	get_tree().current_scene.add_child(flyer)
	flyer.global_position = letterspawn.global_position
	flyer.global_rotation = letterspawn.global_rotation

func spawnnewspaper():
	var paper : newspaper = Library.objs["newspaper"].instantiate()
	get_tree().current_scene.call_deferred("add_child",paper)
	await get_tree().process_frame
	paper.global_position = letterspawn.global_position
	paper.global_rotation = letterspawn.global_rotation.rotated(Vector3.UP,deg_to_rad(90))
	for n in curquests:
		paper.writtenquests.append([n.title,n.desc,n.progress,n.goal,n.checkamount])

func _on_area_3d_body_exited(body: Node3D) -> void:
	ignore.erase(body)

func serializequests():
	var qs = []
	for n in curquests:
		qs.append([n.index,n.progress])
	Savedata.gamedata["curquests"] = qs
