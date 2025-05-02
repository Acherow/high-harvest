extends StaticBody3D

@export var doors : Array[RigidBody3D]
@export var lightboxes : Array[MeshInstance3D]
@export var lights : Array[OmniLight3D]
@onready var anim = $AnimationPlayer

func _ready():
	for door in doors:
		door.freeze = true
	for lightbox in lightboxes:
		var mat : StandardMaterial3D= lightbox.get_surface_override_material(1).duplicate()
		mat.albedo_color = Color.RED
		lightbox.set_surface_override_material(1,mat)
	for light in lights:
		light.light_color = Color.RED

func grabtrigger(pl : Player):
	anim.play("switch")

func unlock():
	for light in lights:
		light.light_color = Color.GREEN
	for lightbox in lightboxes:
		var mat : StandardMaterial3D= lightbox.get_surface_override_material(1).duplicate()
		mat.albedo_color = Color.GREEN
		lightbox.set_surface_override_material(1,mat)
	for door in doors:
		door.freeze = false

func safetymeasure(body):
	if(body is Player):
		unlock()
