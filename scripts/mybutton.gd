extends Label
class_name mybutton

signal pressed

func _ready():
	gui_input.connect(check)

func check(event:InputEvent):
	if(event.is_action_pressed("leftclick")):
		pressed.emit()
