extends Node

var debt : int = 5000
#var incentivegoal : int = 100
#var incentivereward : int = 50

var objs : Dictionary = {
	"farmersguide":load("res://prefabs/farmers guide.tscn"),
	"shovel":load("res://prefabs/shovel.tscn"),
	"hoe":load("res://prefabs/hoe.tscn"),
	"potato":load("res://prefabs/potato.tscn"),
	"potatoling":load("res://prefabs/potatoling.tscn"),
	"dicedpotato":load("res://prefabs/dicedpotato.tscn"),
	"carrot":load("res://prefabs/carrot.tscn"),
	"carrotseed":load("res://prefabs/seedstuff/carrotseed.tscn"),
	"carrotseedbag":load("res://prefabs/seedstuff/carrotseedbag.tscn"),
	"dicedcarrot":load("res://prefabs/dicedcarrot.tscn"),
	"tomato":load("res://prefabs/tomato.tscn"),
	"tomatoseed":load("res://prefabs/seedstuff/tomatoseed.tscn"),
	"tomatoseedbag":load("res://prefabs/seedstuff/tomatoseedbag.tscn"),
	"dicedtomato":load("res://prefabs/dicedtomato.tscn"),
	"turnip":load("res://prefabs/turnip.tscn"),
	"turnipseed":load("res://prefabs/seedstuff/turnipseed.tscn"),
	"turnipseedbag":load("res://prefabs/seedstuff/turnipseedbag.tscn"),
	"dicedturnip":load("res://prefabs/dicedturnip.tscn"),
	"cabbage":load("res://prefabs/cabbage.tscn"),
	"cabbageseed":load("res://prefabs/seedstuff/cabbageseed.tscn"),
	"cabbageseedbag":load("res://prefabs/seedstuff/cabbageseedbag.tscn"),
	"dicedcabbage":load("res://prefabs/dicedcabbage.tscn"),
	"pumpkin":load("res://prefabs/pumpkin.tscn"),
	"pumpkinseed":load("res://prefabs/seedstuff/pumpkinseed.tscn"),
	"pumpkinseedbag":load("res://prefabs/seedstuff/pumpkinseedbag.tscn"),
	"dicedpumpkin":load("res://prefabs/dicedpumpkin.tscn"),
	"wateringcan":load("res://prefabs/watering_can.tscn"),
	"box":load("res://prefabs/box.tscn"),
	"boxlid":load("res://prefabs/lid.tscn"),
	"chicken":load("res://prefabs/chicken.tscn"),
	"rooster":load("res://prefabs/rooster.tscn"),
	"egg":load("res://prefabs/egg.tscn"),
	"pig":load("res://prefabs/pig.tscn"),
	"cow":load("res://prefabs/cow.tscn"),
	"bankstatement":load("res://prefabs/bankstatement.tscn"),
	"receipt":load("res://prefabs/receipt.tscn"),
	"note":load("res://prefabs/note.tscn"),
	"storeflyer":load("res://prefabs/storeflyer.tscn"),
	"trashcan":load("res://prefabs/trashcan.tscn"),
	"trashbag":load("res://prefabs/trashbag.tscn"),
	"newtrashbag":load("res://prefabs/newtrashbag.tscn"),
	"shotgun":load("res://prefabs/shotgun.tscn"),
	"ammobox":load("res://prefabs/ammobox.tscn"),
	"chickenmeat":load("res://prefabs/chickenmeat.tscn"),
	"dicedchickenmeat":load("res://prefabs/dicedchickenmeat.tscn"),
	"crowmeat":load("res://prefabs/crowmeat.tscn"),
	"dicedcrowmeat":load("res://prefabs/dicedcrowmeat.tscn"),
	"pigmeat":load("res://prefabs/pigmeat.tscn"),
	"dicedpigmeat":load("res://prefabs/dicedpigmeat.tscn"),
	"cowmeat":load("res://prefabs/cowmeat.tscn"),
	"dicedcowmeat":load("res://prefabs/dicedcowmeat.tscn"),
	"calendar":load("res://prefabs/calendar.tscn"),
	"nail":load("res://prefabs/nail.tscn"),
	"dice":load("res://prefabs/dice.tscn"),
	"knife":load("res://prefabs/knife.tscn"),
	"bowl":load("res://prefabs/bowl.tscn"),
	"crow":load("res://prefabs/crow.tscn"),
	"lantern":load("res://prefabs/lantern.tscn"),
	"oilbottle":load("res://prefabs/oilbottle.tscn"),
	"scythe":load("res://prefabs/scythe.tscn"),
	"bouncyball":load("res://prefabs/bouncyball.tscn"),
	"gramophone":load("res://prefabs/gramophone.tscn"),
	"pillow":load("res://prefabs/pillow.tscn"),
	"lock":load("res://prefabs/lock.tscn"),
	"key":load("res://prefabs/key.tscn"),
	"pan":load("res://prefabs/pan.tscn"),
	"pot":load("res://prefabs/pot.tscn"),
	"totem":load("res://prefabs/totem.tscn"),
	"sixpack":load("res://prefabs/sixpack.tscn"),
	"beer":load("res://prefabs/beer.tscn"),
	"veggiemanbox":load("res://prefabs/veggiemanbox.tscn"),
	"veggiemaneye":load("res://prefabs/veggiemaneye.tscn"),
	"veggiemanarm":load("res://prefabs/veggiemanarm.tscn"),
	"veggiemanleg":load("res://prefabs/veggiemanleg.tscn"),
	"lawngnome":load("res://prefabs/lawngnome.tscn"),
	"plaque":load("res://prefabs/plaque.tscn"),
	"candle":load("res://prefabs/candle.tscn"),
	"newspaper":load("res://prefabs/newspaper.tscn"),
	"fishingrod":load("res://prefabs/fishingrod.tscn"),
	"baitcan":load("res://prefabs/baitcan.tscn"),
	"vinyl1":load("res://prefabs/vinyl1.tscn"),
	"vinyl2":load("res://prefabs/vinyl2.tscn"),
	"fish1":load("res://prefabs/fish1.tscn"),
	"fish2":load("res://prefabs/fish2.tscn"),
	"fish3":load("res://prefabs/fish3.tscn"),
	"fish4":load("res://prefabs/fish4.tscn"),
	"fish5":load("res://prefabs/fish5.tscn"),
	"squid":load("res://prefabs/squid.tscn"),
	"dicedfish1":load("res://prefabs/dicedfish1.tscn"),
	"dicedfish2":load("res://prefabs/dicedfish2.tscn"),
	"dicedfish3":load("res://prefabs/dicedfish3.tscn"),
	"dicedfish4":load("res://prefabs/dicedfish4.tscn"),
	"dicedsquid":load("res://prefabs/dicedsquidmeat.tscn"),
	"rat":load("res://prefabs/rat.tscn"),
	"milkbottle":load("res://prefabs/milkbottle.tscn"),
}

var invobjs : Dictionary = {
	"bankstatement":load("res://invobjs/bankstatement.tres"),
	"farmersguide":load("res://invobjs/farmersguide.tres"),
	"receipt":load("res://invobjs/receipt.tres"),
	"note":load("res://invobjs/note.tres"),
	"shovel":load("res://invobjs/shovel.tres"),
	"hoe":load("res://invobjs/hoe.tres"),
	"potato":load("res://invobjs/potato.tres"),
	"dicedpotato":load("res://invobjs/dicedpotato.tres"),
	"carrot":load("res://invobjs/carrot.tres"),
	"carrotseed":load("res://invobjs/carrotseed.tres"),
	"carrotseedbag":load("res://invobjs/carrotseedbag.tres"),
	"dicedcarrot":load("res://invobjs/dicedcarrot.tres"),
	"tomato":load("res://invobjs/tomato.tres"),
	"tomatoseed":load("res://invobjs/tomatoseed.tres"),
	"tomatoseedbag":load("res://invobjs/tomatoseedbag.tres"),
	"dicedtomato":load("res://invobjs/dicedtomato.tres"),
	"turnip":load("res://invobjs/turnip.tres"),
	"turnipseed":load("res://invobjs/turnipseed.tres"),
	"turnipseedbag":load("res://invobjs/turnipseedbag.tres"),
	"dicedturnip":load("res://invobjs/dicedturnip.tres"),
	"cabbage":load("res://invobjs/cabbage.tres"),
	"cabbageseed":load("res://invobjs/cabbageseed.tres"),
	"cabbageseedbag":load("res://invobjs/cabbageseedbag.tres"),
	"dicedcabbage":load("res://invobjs/dicedcabbage.tres"),
	"pumpkin":load("res://invobjs/pumpkin.tres"),
	"pumpkinseed":load("res://invobjs/pumpkinseed.tres"),
	"pumpkinseedbag":load("res://invobjs/pumpkinseedbag.tres"),
	"dicedpumpkin":load("res://invobjs/dicedpumpkin.tres"),
	"wateringcan":load("res://invobjs/wateringcan.tres"),
	"storeflyer":load("res://invobjs/storeflyer.tres"),
	"box":load("res://invobjs/box.tres"),
	"boxlid":load("res://invobjs/lid.tres"),
	"chicken":load("res://invobjs/chicken.tres"),
	"rooster":load("res://invobjs/rooster.tres"),
	"egg":load("res://invobjs/egg.tres"),
	"pig":load("res://invobjs/pig.tres"),
	"cow":load("res://invobjs/cow.tres"),
	"trashcan":load("res://invobjs/trashcan.tres"),
	"trashbag":load("res://invobjs/trashbag.tres"),
	"newtrashbag":load("res://invobjs/newtrashbag.tres"),
	"shotgun":load("res://invobjs/shotgun.tres"),
	"ammobox":load("res://invobjs/ammobox.tres"),
	"chickenmeat":load("res://invobjs/chickenmeat.tres"),
	"dicedchickenmeat":load("res://invobjs/dicedchickenmeat.tres"),
	"crowmeat":load("res://invobjs/crowmeat.tres"),
	"dicedcrowmeat":load("res://invobjs/dicedcrowmeat.tres"),
	"pigmeat":load("res://invobjs/pigmeat.tres"),
	"dicedpigmeat":load("res://invobjs/dicedpigmeat.tres"),
	"cowmeat":load("res://invobjs/cowmeat.tres"),
	"dicedcowmeat":load("res://invobjs/dicedcowmeat.tres"),
	"calendar":load("res://invobjs/calendar.tres"),
	"nail":load("res://invobjs/nail.tres"),
	"dice":load("res://invobjs/dice.tres"),
	"knife":load("res://invobjs/knife.tres"),
	"bowl":load("res://invobjs/bowl.tres"),
	"crow":load("res://invobjs/crow.tres"),
	"lantern":load("res://invobjs/lantern.tres"),
	"oilbottle":load("res://invobjs/oilbottle.tres"),
	"scythe":load("res://invobjs/scythe.tres"),
	"bouncyball":load("res://invobjs/bouncyball.tres"),
	"gramophone":load("res://invobjs/gramophone.tres"),
	"pillow":load("res://invobjs/gramophone.tres"),
	"lock":load("res://invobjs/lock.tres"),
	"key":load("res://invobjs/key.tres"),
	"pan":load("res://invobjs/pan.tres"),
	"pot":load("res://invobjs/pot.tres"),
	"totem":load("res://invobjs/totem.tres"),
	"sixpack":load("res://invobjs/sixpack.tres"),
	"beer":load("res://invobjs/beer.tres"),
	"veggiemanbox":load("res://invobjs/veggiemanbox.tres"),
	"veggiemaneye":load("res://invobjs/veggiemaneye.tres"),
	"veggiemanarm":load("res://invobjs/veggiemanarm.tres"),
	"veggiemanleg":load("res://invobjs/veggiemanleg.tres"),
	"lawngnome":load("res://invobjs/lawngnome.tres"),
	"plaque":load("res://invobjs/plaque.tres"),
	"candle":load("res://invobjs/candle.tres"),
	"newspaper":load("res://invobjs/newspaper.tres"),
	"fishingrod":load("res://invobjs/fishingrod.tres"),
	"baitcan":load("res://invobjs/baitcan.tres"),
	"vinyl1":load("res://invobjs/vinyl1.tres"),
	"vinyl2":load("res://invobjs/vinyl2.tres"),
	"fish1":load("res://invobjs/fish1.tres"),
	"fish2":load("res://invobjs/fish2.tres"),
	"fish3":load("res://invobjs/fish3.tres"),
	"fish4":load("res://invobjs/fish4.tres"),
	"fish5":load("res://invobjs/fish5.tres"),
	"squid":load("res://invobjs/squid.tres"),
	"dicedfish1":load("res://invobjs/dicedfish1.tres"),
	"dicedfish2":load("res://invobjs/dicedfish2.tres"),
	"dicedfish3":load("res://invobjs/dicedfish3.tres"),
	"dicedfish4":load("res://invobjs/dicedfish4.tres"),
	"dicedsquid":load("res://invobjs/dicedsquid.tres"),
	"rat":load("res://invobjs/rat.tres"),
	"milkbottle":load("res://invobjs/milkbottle.tres"),
}

var purchasables : Dictionary = {
	"carrotseedbag" = 10.0,
	"tomatoseedbag" = 10.0,
	"turnipseedbag" = 10.0,
	"cabbageseedbag" = 10.0,
	"pumpkinseedbag" = 10.0,
	"potato" = 5.0,
	"shovel" = 9.0,
	"wateringcan" = 8.0,
	"chicken" = 17.0,
	"rooster" = 30.0,
	"pig" = 20.0,
	"cow" = 20.0,
	"newtrashbag" = 5.0,
	"trashcan" = 10.0,
	#"shotgun" = 30.0,
	"ammobox" = 5.0,
	"nail" = 1.0,
	"calendar" = 10.0,
	"dice" = 1.0,
	"lantern" = 40.0,
	"oilbottle" = 10.0,
	"bouncyball" = 1.0,
	"key" = 50.0,
	"knife" = 15.0,
	"pot" = 20.0,
	"sixpack" = 20.0,
	"veggiemanbox" = 10.0,
	"lawngnome" = 5.0,
	"candle" = 5.0,
	"milkbottle" = 1.0,
}

var sellvalues : Dictionary = {
	"carrot" = 5.0,
	"tomato" = 5.0,
	"turnip" = 5.0,
	"cabbage" = 7.0,
	"pumpkin" = 10.0,
	"potato" = 9.0,
	"fish1" = 10.0,
	"fish2" = 10.0,
	"fish3" = 10.0,
	"fish4" = 10.0,
	"squid" = 15.0,
	"egg" = 7.0,
	"trashbag" = 1.0,
	"ammobox" = 5.0,
	"used ammobox" = 0.99,
	"chickenmeat" = 20.0,
	"crowmeat" = 6.0,
	"pigmeat" = 30.0,
	"cowmeat" = 30.0,
	"rotten meat" = 0.00,
	"spoiled food" = 0.00,
	"carrotseedbag" = 10.0,
	"tomatoseedbag" = 10.0,
	"turnipseedbag" = 10.0,
	"usedseedbag" = 1.0,
	"totem" = 100.0,
	"usedsixpack"= 1.0,
	"milk" = 10.0,
}

const crops : Dictionary = {
	"crophole":preload("res://prefabs/crops/hole.tscn"),
	"carrotseed":preload("res://prefabs/crops/carrotcrop.tscn"),
	"tomatoseed":preload("res://prefabs/crops/tomatocrop.tscn"),
	"turnipseed":preload("res://prefabs/crops/turnipcrop.tscn"),
	"cabbageseed":preload("res://prefabs/crops/cabbagecrop.tscn"),
	"dicedpotato":preload("res://prefabs/crops/potatocrop.tscn"),
}

const fish : Dictionary = {
	"fish1":3,
	"fish2":3,
	"fish3":3,
	"fish4":3,
	"fish5":1,
	"squid":2,
}

const critters : Dictionary = {
	"worm":preload("res://prefabs/worm.tscn"),
}

const others : Dictionary = {
	"table":preload("res://prefabs/table.tscn"),
	"truck":preload("res://prefabs/truck.tscn"),
	"bedframe":preload("res://prefabs/bedframe.tscn"),
	"scarecrow":preload("res://prefabs/scarecrow.tscn"),
	"stove":preload("res://prefabs/stove.tscn"),
	"mattress":preload("res://prefabs/mattress.tscn"),
	"closet":preload("res://prefabs/closet.tscn"),
	"woodenbox":preload("res://prefabs/woodenbox.tscn"),
	"wickerman1":preload("res://prefabs/wickerman.tscn"),
}

const scenes : Array = [
	"res://scenes/world.tscn", #0
	"res://scenes/cellar.tscn", #1
]

signal sold(item, value)
func sell(item : String) -> float:
	if(Library.sellvalues.has(item)):
		if(Savedata.gamedata["stocks"].has(item)):
			var returnvalue = Library.sellvalues[item] * Savedata.gamedata["stocks"][item]
			returnvalue = snapped(returnvalue,.01)
			Savedata.gamedata["money"] += returnvalue
			sold.emit(item,returnvalue)
			#Savedata.gamedata["stocks"][item] = clamp(Savedata.gamedata["stocks"][item] - (0.01),0.5,2)
			return returnvalue
		else:
			var returnvalue = Library.sellvalues[item]
			Savedata.gamedata["money"] += returnvalue
			Savedata.gamedata["totalmoney"] += returnvalue
			sold.emit(item,returnvalue)
			return Library.sellvalues[item]
	elif(Library.purchasables.has(item)):
		var returnvalue = Library.sellvalues[item]
		Savedata.gamedata["money"] += returnvalue
		Savedata.gamedata["totalmoney"] += returnvalue
		Savedata.gamedata["curincentivegoal"] -= returnvalue
		sold.emit(item,returnvalue)
		return Library.purchasables[item]
	else:
		return 0

func marketmutate():
	for n in Savedata.gamedata["stocks"]:
		var rng = randi_range(-3,5) / 10
		Savedata.gamedata["stocks"][n] = clamp(Savedata.gamedata["stocks"][n] + rng,0.5,2)

func calc_angular_velocity(from_basis: Basis, to_basis: Basis) -> Vector3:
	var q1 = from_basis.get_rotation_quaternion()
	var q2 = to_basis.get_rotation_quaternion()

	# Quaternion that transforms q1 into q2
	var qt = q2 * q1.inverse()

	# Angle from quaternion
	var angle = 2 * acos(qt.w)

	# There are two distinct quaternions for any orientation.
	# Ensure we use the representation with the smallest angle.
	if angle > PI:
		qt = -qt
		angle = TAU - angle

	# Prevent divide by zero
	if angle < 0.0001:
		return Vector3.ZERO

	# Axis from quaternion
	var axis = Vector3(qt.x, qt.y, qt.z) / sqrt(1-qt.w*qt.w)

	return axis * angle

func timetransition(t : float) -> String:
	var minute = str(floor(t/60)).pad_zeros(2).pad_decimals(0)
	var hour = str(floor(floor(t/60)/60)).pad_zeros(2).pad_decimals(0)
	var seconds = str(fmod(t, 60)).pad_zeros(2).pad_decimals(0)
	return hour + ":" + minute + ":" + seconds
