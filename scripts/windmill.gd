extends Node3D

@onready var anim: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	anim.seek(randf_range(0.0,4.0))
	anim.play("spin")
