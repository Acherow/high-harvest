extends Node3D

var camangle : float = 0.0

@onready var cam = $Camera3D

const NEWGAME = preload("res://prefabs/uistuff/newgame_ui.tscn")
const SAVESLOT = preload("res://prefabs/uistuff/save_slot_ui.tscn")
@onready var savecontainer = $saves/viewportcont2/SubViewport/ColorRect/VBoxContainer
@onready var volumeslider = $options/viewportcont2/SubViewport/ColorRect/Panel/VBoxContainer/volumeslider
@onready var sensitivityslider = $options/viewportcont2/SubViewport/ColorRect/Panel/VBoxContainer/sensitivityslider

var saveslots = []
func _ready():
	volumeslider.value = Savedata.settings["volume"]
	_on_volumeslider_value_changed(Savedata.settings["volume"])
	sensitivityslider.value = Savedata.settings["sensitivity"]
	_on_sensitivityslider_value_changed(Savedata.settings["sensitivity"])
	for n in Savedata.datacount():
		var sl = SAVESLOT.instantiate()
		sl.file = n
		savecontainer.add_child(sl)
		sl.clicked.connect(loadgame)
		saveslots.append(sl)
	var ng = NEWGAME.instantiate()
	ng.gui_input.connect(newgame)
	ng.mouse_exited.connect(func(): ng.color = Color("b70000"))
	ng.mouse_entered.connect(func(): ng.color = Color("d45800"))
	savecontainer.add_child(ng)

func updateslots():
	for n in saveslots.size():
		saveslots[n].file = n
		saveslots[n].refresh() 

func loadgame(id:int):
	Savedata.curfile = id
	Savedata.load_data()
	var scn = Library.scenes[Savedata.gamedata["playerscene"]]
	get_tree().change_scene_to_file(scn)

func newgame(event):
	if(event.is_action_pressed("leftclick")):
		Savedata.curfile = Savedata.datacount()
		Savedata.load_data()
		get_tree().change_scene_to_file("res://scenes/world.tscn")

func _process(delta):
	cam.rotation_degrees.y = lerp(cam.rotation_degrees.y,camangle,delta*10)

func lookatsaves():
	camangle = -90

func backtomain():
	camangle = 0

func lookatoptions():
	camangle = 90

func quit():
	get_tree().quit()

func _on_sensitivityslider_value_changed(value):
	Savedata.settings["sensitivity"] = value
	Savedata.savesettings()

func _on_volumeslider_value_changed(value):
	Savedata.settings["volume"] = value
	Savedata.savesettings()
	AudioServer.set_bus_volume_db(0,linear_to_db(value))
