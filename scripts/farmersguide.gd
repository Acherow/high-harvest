extends RigidBody3D

@onready var textstuff: CanvasLayer = $textstuff

@export var imgs : Array[Texture2D]
var curindex : int = 0

@onready var texture: TextureRect = $textstuff/ColorRect/TextureRect
@onready var left: TextureButton = $textstuff/ColorRect/left
@onready var right: TextureButton = $textstuff/ColorRect/right

func _ready() -> void:
	left.visible = false
	texture.texture = imgs[0]

func flip(fwd : bool):
	curindex += (1 if fwd else -1)
	curindex = clamp(curindex,0,imgs.size()-1)
	left.visible = curindex != 0
	right.visible = curindex != imgs.size()-1
	texture.texture = imgs[curindex]

var plref

func trigger(pl):
	plref = pl
	if(pl.inventory.visible):
		return
	
	var on = !textstuff.visible
	pl.camfrozen = on
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED if !on else Input.MOUSE_MODE_VISIBLE)
	textstuff.visible = on
	if(!on):
		plref = null

func _input(event):
	if(plref && textstuff.visible && (event.is_action_pressed("inventory") || event.is_action_pressed("grab") || event.is_action_pressed("hold"))):
		plref.camfrozen = false
		textstuff.visible = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func info():
	return "Press [LMB] to read."
