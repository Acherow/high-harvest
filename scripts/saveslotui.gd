extends ColorRect

var file : int = 0
@onready var label = $Label
@onready var label2 = $Label2

@export var regularcolor : Color
@export var hovercolor : Color

@onready var trash = $TextureRect

func _ready():
	refresh()
	mouse_entered.connect(func(): color = hovercolor)
	mouse_exited.connect(func(): color = regularcolor)

func refresh():
	label.text = "SAVE " + str(file+1)
	var data = Savedata.loadonce(file)
	if(data != null):
		#return
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


func _on_button_mouse_entered():
	trash.modulate = Color.YELLOW


func _on_button_mouse_exited():
	trash.modulate = Color.WHITE
