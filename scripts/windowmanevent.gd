extends Area3D

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var man: Sprite3D = $Sprite3D

var shown : bool = false

func _on_body_entered(body: Node3D) -> void:
	if(body.is_in_group("player")):
		anim.play("show")
		shown = true

func _process(delta: float) -> void:
	if(shown && !anim.is_playing() && InfoChecker.visibletoplayer(man.global_position)):
		anim.play("hide")

func _on_body_exited(body: Node3D) -> void:
	if(!anim.is_playing() && body.is_in_group("player")):
		anim.play("hide")
