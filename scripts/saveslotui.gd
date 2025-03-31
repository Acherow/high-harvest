extends ColorRect

var file : int = 0
@onready var label = $Label
@onready var label2 = $Label2

func _ready():
	refresh()

func refresh():
	label.text = "SAVE " + str(file+1)
	var data = Savedata.loadonce(file)
	if(data != null):
		label2.text = "%s\n$%.2f" % [Library.timetransition(data["playtime"]),data["money"]]

func deletesave():
	Savedata.delete_data(file)
	queue_free()

signal clicked(fil)
func _on_gui_input(event):
	if(event.is_action_pressed("leftclick")):
		clicked.emit(file)


func _on_texture_rect_gui_input(event):
	if(event.is_action_pressed("leftclick")):
		deletesave()
