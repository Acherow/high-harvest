extends basepickup

@onready var shape: CollisionShape3D = $CollisionShape3D
@onready var wickpos: Node3D = $wickpos
@onready var candle: MeshInstance3D = $candle
@onready var particles: GPUParticles3D = $wickpos/GPUParticles3D
@onready var light: OmniLight3D = $wickpos/OmniLight3D

var shap : CylinderShape3D
var on : bool = false
var height = 1

var data : InventoryObject

func _ready() -> void:
	super()
	shap = shape.shape.duplicate()
	await get_tree().process_frame
	data = get_meta("obj").duplicate()
	set_meta("obj", data)
	if(data.customproperties.has("height")):
		height = data.customproperties["height"]
	else:
		height = 1
		data.customproperties["height"] = height
		set_meta("obj", data)
	updatesh()

func _process(delta: float) -> void:
	if(on):
		height -= delta * .005
		updatesh()
		data.customproperties["height"] = height
		if(height <= 0.1):
			queue_free()
	particles.emitting = on
	light.visible = on

func trigger(bod):
	on = !on

func updatesh():
	shap.height = .45 * height
	shape.shape = shap
	candle.scale.y = height
	wickpos.position.y = 0.25 * height

func heat(bo):
	if(bo):
		on = true
