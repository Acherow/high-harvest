extends Node3D

var camangle : float = 0.0

@onready var cam = $Camera3D

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
