extends RigidBody3D

@export var lockangle : float
var locked : bool = true
@onready var audio: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var audio2: AudioStreamPlayer3D = $AudioStreamPlayer3D3

func _physics_process(delta):
	if(locked && rotation_degrees.x!= lockangle):
		rotation_degrees.x = lockangle

func grabtrigger(_obj):
	if(abs(rotation_degrees.x - lockangle) <= 3):
		audio2.play()
	locked = false

func endgrabtrigger(_obj):
	if(abs(rotation_degrees.x - lockangle) <= 3):
		locked = true
		audio.play()
