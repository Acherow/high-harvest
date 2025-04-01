extends basepickup

var data : InventoryObject

var worms : int = 0

func _ready() -> void:
	super()
	await get_tree().process_frame
	data = get_meta("obj").duplicate()
	set_meta("obj", data)
	if(data.customproperties.has("worms")):
		worms = data.customproperties["worms"]
	else:
		worms = 0
		data.customproperties["worms"] = worms
		set_meta("obj", data)

func _on_body_entered(body):
	if(body is fishingrod && !body.wormed && worms > 0):
		body.wormed = true
		worms -= 1
		updatedata()
	if(body is worm):
		body.queue_free()
		worms += 1

func updatedata():
	if(data == null):
		data = get_meta("obj").duplicate()
	data.customproperties["worms"] = worms
	set_meta("obj", data)

func info():
	return "Worms: %d" % worms
