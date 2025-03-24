extends Resource
class_name Quest


@export var title : String
@export var desc : String
@export var itemtype : String
@export var checkamount : bool

@export var repeatable : bool
@export var progress : float
@export var goal : float

@export var unlockreward : Array
@export var cashreward : float

var index : int = 0

func check(item, value):
	if(itemtype == item || itemtype == ""):
		if(checkamount):
			progress += 1
		else:
			progress += value

func reward():
	var str = "You've completed a listing"
	if(unlockreward != null && !Savedata.gamedata.unlocks.has(unlockreward[0])):
		str += ". A new item is on sale"
		Savedata.gamedata.unlocks[unlockreward[0]] = unlockreward[1]
	if(cashreward != 0):
		str += " and you've received $%.2f" % cashreward
		Savedata.gamedata["money"] += cashreward
	str += "."
	return str
