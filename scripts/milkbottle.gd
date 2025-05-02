extends basepickup

@export var fullmat : Material
@export var emptymat : Material
@onready var bottle = $bottle

const EMPTY = preload("res://sprites/itemicons/milkbottleempty.png")
const FULL = preload("res://sprites/itemicons/milkbottlefull.png")

var data : InventoryObject

var full : bool = true

func _ready():
	super()
	await get_tree().process_frame
	data = get_meta("obj").duplicate()
	if(data.customproperties.has("full")):
		full = data.customproperties["full"]
	updatemesh()
	set_meta("obj", data)

func updatemesh():
	bottle.set_surface_override_material(1,fullmat if full else emptymat)
	data.icon = FULL if full else EMPTY
	data.customproperties["sellmod"] = "milk" if full else ""

func _on_body_entered(body: Node) -> void:
	if(body is cow && body.milk >= 2):
		full = true
		updatemesh()
		body.milk -= 2

func trigger(pl):
	pl.body.feed(5)
	full = false
	updatemesh()
