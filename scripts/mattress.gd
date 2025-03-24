extends RigidBody3D

@onready var colorfilter = $CanvasLayer/ColorRect
@onready var label = $CanvasLayer/ColorRect/Label

var player : Player

var man

func _ready():
	colorfilter.visible = false
	man = get_tree().get_first_node_in_group("daymanager")

func _input(event):
	if((event.is_action_pressed("pause")||event.is_action_pressed("leftclick")||event.is_action_pressed("grab")||event.is_action_pressed("jump")) && colorfilter.visible == true):
		player.frozen = false
		colorfilter.visible = false
		player = null
		Engine.time_scale = 1
		Engine.physics_ticks_per_second = 120

func _process(delta):
	if(colorfilter.visible):
		label.text = ("%02.0f" % (man.timeofday/100)) + (":00")

func _on_grabarea_grabbed(bod):
	player = bod
	player.frozen = true
	colorfilter.visible = true
	Engine.time_scale = 40
	Engine.physics_ticks_per_second = 120 * Engine.time_scale
	Engine.max_physics_steps_per_frame = 8 * Engine.time_scale
