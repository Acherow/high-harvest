extends Node

const SAVEFILE = "user://saves/SAVEFILE%s.save"

var gamedata = {}
var settings = {}

var curfile = 0

var cansave : int = 0

func _ready():
	load_data()
	if(settings.is_empty()):
		if(FileAccess.file_exists("user://settings.set")):
			var file = FileAccess.open("user://settings.set", FileAccess.READ)
			settings = file.get_var()
		else:
			settings = {
				"sensitivity" : .002,
				"volume" : .5,
			}
			var file = FileAccess.open("user://settings.set", FileAccess.WRITE)
			file.store_var(settings)

func datacount():
	var testfile = 0
	while true:
		if(FileAccess.file_exists(SAVEFILE % testfile)):
			testfile += 1
		else:
			break
	return testfile

func load_data():
	if(!DirAccess.dir_exists_absolute("user://saves")):
		DirAccess.make_dir_absolute("user://saves")
	if(curfile == -1):
		return
	
	if(FileAccess.file_exists(SAVEFILE%curfile)):
		var file = FileAccess.open(SAVEFILE%curfile, FileAccess.READ)
		gamedata = file.get_var()
	else:
		gamedata = {
			"debtpaid":false,
			"playtime":0.0,
			"day": 0,
			"timeofday": 500,
			"money": 50,
			"totalmoney":0,
			#"curincentivegoal":100,
			"playerscene":0,
			"raintime":1400,
			"israining":false,
			"crouched":false,
			"player": [Vector3(-45,0.5,160), Vector3(0,0,0), 50,50,[["note",{ "text":"DEED OF LAND AGREEMENT\n\nThrough this document we pronounce ██████████ the owner of ██████ farm, located on ████████, ████████, in exchange for $%.2f to be paid in labor at the farm." % Library.debt }]], ["farmersguide", {}],[]],
			"objects0": [
				["pickup",Vector3(-28.1, 2.5, -25.3), Vector3(0, deg_to_rad(90), 0), "calendar", {  }], 
				["pickup",Vector3(-28.05, 2.75, -25.3), Vector3(0, deg_to_rad(90), 0), "nail", {  }], 
				["pickup",Vector3(-16.8, 2.57, -20.3), Vector3(0, deg_to_rad(90), 0), "lantern", {  }], 
				["pickup",Vector3(-27.4, 1.9, -21.8), Vector3(0, deg_to_rad(180), 0), "pillow", {  }], 
				["pickup",Vector3(-16.9, 1.2, -21.6), Vector3(deg_to_rad(15), 0, 0), "shovel", {  }], 
				["pickup",Vector3(-20, 1.8, -22), Vector3(0, 0, 0), "wateringcan", {  }], 
				["pickup",Vector3(-20.1, 1.85, -23), Vector3(0, deg_to_rad(90), 0), "carrotseedbag", {  }], 
				["pickup",Vector3(-27.908, 0.923, -31.43), Vector3(deg_to_rad(-60), deg_to_rad(-90), 0), "lock", {  }], 
				["pickup",Vector3(-17.1, 1.6, -28.4), Vector3(0, 0, 0), "pan", {  }], 
				["pickup",Vector3(-21.3, 1.9, -22.2), Vector3(0, 0, 0), "candle", {  }], 
				["pickup",Vector3(-50, 2, 177), Vector3(0, 0, 0), "gramophone", {  }], 
				["pickup",Vector3(-50, 2.1, 177), Vector3(0, 0, 0), "vinyl1", {  }], 
				#["pickup",Vector3(-49.6, 1.62, 175), Vector3(deg_to_rad(-90), deg_to_rad(-90), 0), "farmersguide", { }], 
				#["pickup",Vector3(-49.25, 1.6, 175.05), Vector3(deg_to_rad(-90), 0, 0), "note", ], 
				#["pickup",Vector3(-22.25, 2.55, -27.3), Vector3(0, deg_to_rad(-90), 0), "nail", { }], 
				["pickup",Vector3(-20.2, 0.9, -22.2), Vector3(0, 0, 0), "box", {  }], 
				["pickup",Vector3(-20.2, 1.1, -22.2), Vector3(0, 0, 0), "boxlid", {  }], 
				["other", "table", Vector3(-20.9, 1.4, -22.6), Vector3(0, 0, 0)], 
				["other", "truck", Vector3(-50, .5, 155), Vector3(0, 0, 0), {"seated":true, "lights":true}], 
				["other", "closet", Vector3(-22.75, .5, -22.2), Vector3(0, deg_to_rad(-90), 0)], 
				["other", "bedframe", Vector3(-27.4, 1.2, -22.6), Vector3(0, deg_to_rad(-180), 0)], 
				["other", "mattress", Vector3(-27.4, 1.7, -22.6), Vector3(0, deg_to_rad(-180), 0)], 
				["other", "stove", Vector3(-16.9, 1, -28.6), Vector3(0, deg_to_rad(90), 0),{"fuel":10.0}], 
				#["other", "wickerman1", Vector3(-5, 1.7, -5), Vector3(0, deg_to_rad(-180), 0)], 
				],
			"objects1": [
				["pickup",Vector3(0.7, 0.68, -5.82), Vector3(0, 0, 0), "lock", {  }], 
				["pickup",Vector3(33.824, 0.68, -43.294), Vector3(0, deg_to_rad(-90), 0), "lock", {  }], 
				["pickup",Vector3(-37.93, 0.68, -36.726), Vector3(0, deg_to_rad(90), 0), "lock", {  }], 
				["pickup",Vector3(-2, 0.5, -5.6), Vector3(deg_to_rad(75), 0, 0), "shotgun", {  }], 
				["other", "wickerman1", Vector3(3.3, 1.5, -18.5), Vector3(0, 0, 0)], 
				["other", "wickerman1", Vector3(12.8, 1.5, -27), Vector3(0, 0, 0)], 
				["other", "wickerman1", Vector3(18.7, 1.5, -43.5), Vector3(0, 0, 0)], 
				["other", "wickerman1", Vector3(-27.2, 1.5, -44), Vector3(0, 0, 0)], 
				["other", "wickerman1", Vector3(4.3, 1.5, -51.5), Vector3(0, 0, 0)], 
				["other", "wickerman1", Vector3(22.8, 1.5, -59), Vector3(0, 0, 0)], 
				["other", "wickerman1", Vector3(40.3, 1.5, -11.5), Vector3(0, 0, 0)], 
				["other", "wickerman1", Vector3(40.3, 1.5, -35), Vector3(0, 0, 0)], 
				["other", "wickerman1", Vector3(-15.2, 1.5, -60), Vector3(0, 0, 0)], 
				["other", "wickerman1", Vector3(7.3, 1.5, -60), Vector3(0, 0, 0)], 
				["other", "wickerman1", Vector3(-28.2, 1.5, -68), Vector3(0, 0, 0)], 
				["other", "wickerman1", Vector3(31.3, 1.5, -83), Vector3(0, 0, 0)], 
				["other", "woodenbox", Vector3(-15, 0.5, -20), Vector3(0, 0, 0)], 
				["pickup",Vector3(-15, 1.25, -20), Vector3(0, 0, 0), "oilbottle", {  }], 
				["other", "woodenbox", Vector3(27, 0.5, -20), Vector3(0, 0, 0)], 
				["other", "woodenbox", Vector3(28.5, 0.5, -21), Vector3(0, deg_to_rad(-15), 0)], 
				["pickup",Vector3(27, 1.25, -20), Vector3(0, 0, 0), "turnip", {  }], 
				["pickup",Vector3(40.3, 1.5, -35.4), Vector3(deg_to_rad(180), 0, 0), "knife", {  }], 
				["other", "woodenbox", Vector3(0, 0.5, -90), Vector3(0, 0, 0)], 
				["other", "woodenbox", Vector3(100, 0.5, -28), Vector3(0, 0, 0)], 
				["other", "woodenbox", Vector3(41.4, 0.5, -60), Vector3(0, deg_to_rad(8.7), 0)], 
				["other", "chair", Vector3(83.147, .9, -15.5), Vector3(0, deg_to_rad(-17.5), 0)], 
				["other", "chair", Vector3(19, .9, -11), Vector3(0, deg_to_rad(-41.5), 0)], 
				["other", "chair", Vector3(-5, .8, 12), Vector3(0, deg_to_rad(-45), 0)], 
				["other", "chair", Vector3(51, .8, -84), Vector3(0, deg_to_rad(90), 0)], 
				["other", "closet", Vector3(47, 0, -79.5), Vector3(0, deg_to_rad(105), 0)], 
				["other", "barrel", Vector3(63, 0.6, -89), Vector3(0, 0, 0)], 
				["other", "barrel", Vector3(-29, 0.6, -69), Vector3(0, 0, 0)], 
				["other", "barrel", Vector3(-47, 0.6, -61), Vector3(0, 0, 0)], 
				["pickup",Vector3(-47, 1.4, -21), Vector3(0, 0, 0), "cabbageseedbag", {  }], 
				["pickup",Vector3(100, 1.3, -28), Vector3(0, 0, 0), "wateringcan2", {  }], 
				["pickup",Vector3(100, .5, -20), Vector3(0, 0, 0), "hoe", {  }], 
				["pickup",Vector3(50, .5, -84), Vector3(0, 0, 0), "hoe", {  }], 
				["pickup",Vector3(0, 1.3, -90), Vector3(0, 0, 0), "totem", {  }], 
				["pickup",Vector3(-13, 2.15, -29.6), Vector3(0, 0, 0), "ammobox", {  }], 
				["pickup",Vector3(-14.5, 2.25, -29.6), Vector3(0, 0, 0), "milkbottle", {  }], 
				["pickup",Vector3(-15, 2.25, -29.6), Vector3(0, 0, 0), "milkbottle", {  }], 
				["pickup",Vector3(-15.5, 2.25, -29.6), Vector3(0, 0, 0), "milkbottle", {  }], 
				["pickup",Vector3(11, 2.32, -21.6), Vector3(0, 0, 0), "candle", {  }], 
				["pickup",Vector3(10.5, 2.32, -21.6), Vector3(0, 0, 0), "candle", {  }], 
				["pickup",Vector3(9.5, 2.2, -21.6), Vector3(0, 0, deg_to_rad(-90)), "candle", {  }], 
				["pickup",Vector3(-82.3, 2.1, -16.3), Vector3(0, 0, 0), "vinyl2", {  }], 
				["pickup",Vector3(-1, 2.35, -29.7), Vector3(0, deg_to_rad(180), 0), "lawngnome", {  }], 
				["pickup",Vector3(77, 0.5, -27.5), Vector3(deg_to_rad(-90), 0, 0), "fishingrod", {  }], 
				["pickup",Vector3(-51, 0.9, -84.25), Vector3(0, deg_to_rad(90), deg_to_rad(90)), "scythe", {  }], 
				["other", "scarecrow", Vector3(-12, 0.4, -75), Vector3(0, -180, 0)], 
				["other", "mudangel", Vector3(88, 0, -16), Vector3(0, 0, 0)], 
				["other", "mudangel", Vector3(77, 0, -36), Vector3(0, -90, 0)], 
				["other", "mudangel", Vector3(65, 0, -44), Vector3(0, 0, 0)], 
				["other", "mudangel", Vector3(58, 0, -72), Vector3(0, 0, 0)], 
				["other", "mudangel", Vector3(58, 0, -90), Vector3(0, 0, 0)], 
				["other", "mudangel", Vector3(72, 0, -60), Vector3(0, 0, 0)], 
				["pickup",Vector3(-20, 2, -21.95), Vector3(0, 0, 0), "painting1", {  }], 
				["pickup",Vector3(-20, 2.47, -21.9), Vector3(0, 0, 0), "nail", {  }], 
				["pickup",Vector3(20, 2, -37.95), Vector3(0, 0, 0), "painting2", {  }], 
				["pickup",Vector3(20, 2.47, -37.9), Vector3(0, 0, 0), "nail", {  }], 
				["pickup",Vector3(60, 2, -34.05), Vector3(0, deg_to_rad(180), 0), "painting2", {  }], 
				["pickup",Vector3(60, 2.47, -34.1), Vector3(0, deg_to_rad(180), 0), "nail", {  }], 
				["pickup",Vector3(46.025, 2, -83.9), Vector3(0, deg_to_rad(90), 0), "painting3", {  }], 
				["pickup",Vector3(46.075, 2.47, -83.9), Vector3(0, deg_to_rad(90), 0), "nail", {  }], 
				["pickup",Vector3(-41.975, 2, -83.9), Vector3(0, deg_to_rad(90), 0), "painting3", {  }], 
				["pickup",Vector3(-41.925, 2.47, -83.9), Vector3(0, deg_to_rad(90), 0), "nail", {  }], 
			],
			"stocks": {
					"carrot":1,
					"tomato":1,
					"turnip":1,
					"cabbage":1,
					"potato":1,
				},
			"daysales": {
					"carrot":0,
					"tomato":0,
					"turnip":0,
					"cabbage":0,
					"potato":0,
					"pumpkin":0,
				},
			"seenevents": {
				
			},
			"unlocks": {
				#"scythe" = 100.0,
				#"hoe" = 100.0,
			},
			"curquests": [
				#[0,0,false]
			],
			"completedquests": [
				
			]
		}
	cansave = 0
	return gamedata

func resetsales():
	gamedata["daysales"] = {
	"carrot":0,
	"tomato":0,
	"turnip":0,
	"cabbage":0,
	"potato":0,
	"pumpkin":0,
	}

func savesettings():
	var file = FileAccess.open("user://settings.set", FileAccess.WRITE)
	file.store_var(settings)

func save_data():
	if(curfile != -1 && cansave == 0):
		var file = FileAccess.open(SAVEFILE % curfile, FileAccess.WRITE)
		file.store_var(gamedata)

func loadonce(dat : int):
	if(FileAccess.file_exists(SAVEFILE%dat)):
		return FileAccess.open(SAVEFILE%dat, FileAccess.READ).get_var()
	else:
		return null

func delete_data(dat : int):
	if(FileAccess.file_exists(SAVEFILE%dat)):
		DirAccess.remove_absolute(SAVEFILE%dat)
		var list = DirAccess.get_files_at("user://saves")
		for n in list.size():
			DirAccess.rename_absolute("user://saves/"+list[n], SAVEFILE%n)
			
