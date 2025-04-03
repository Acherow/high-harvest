extends Label
class_name mybutton

signal pressed

@export var regularlook : LabelSettings
@export var hoverlook : LabelSettings

func _ready():
	gui_input.connect(check)
	mouse_entered.connect(func():label_settings = hoverlook)
	mouse_exited.connect(func():label_settings = regularlook)

func check(event:InputEvent):
	if(event.is_action_pressed("leftclick")):
		pressed.emit()
