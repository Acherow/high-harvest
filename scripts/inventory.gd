extends Control
class_name Inventory

var invlist : Array = []

var selected : InventoryObject = null

@onready var body = $"../../.."
@onready var listcont = $VBoxContainer
const item = preload("res://prefabs/listitem.tscn")
@onready var anim: AnimationPlayer = $AnimationPlayer

@onready var item_name = $"descbox/item name"
@onready var item_desc = $"descbox/item desc"
@onready var itemweight = $descbox/itemweight
@onready var itemicon = $picturebox/itemicon
@onready var totalweight = $weightbox/totalweight

@export var maxweight : float = 5.0
@export var currentweight : float = 0.0

var listheight : int

signal spawn(obj)

func _ready():
	display(null)

func _input(event):
	if(visible):
		if(event.is_action_pressed("hold") || event.is_action_pressed("leftclick") && selected != null):
			spawn.emit(selected)
			invlist.erase(selected)
			display(null)
			UpdateList()
			hideInv()
			body.cam.camfrozen = false
		if(listheight > 250):
			if(event.is_action_pressed("MWD")):
				listcont.position.y = clamp(listcont.position.y-10, -(listheight-350),0)
			if(event.is_action_pressed("MWU")):
				listcont.position.y = clamp(listcont.position.y+10, -(listheight-350),0)

var extfrozen : bool = false
func showInv():
	anim.play("show")
	visible = true
	extfrozen = body.frozen
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	UpdateList()

func hideInv():
	await get_tree().process_frame
	anim.play("hide")

func actualhide():
	visible = false
	if(!extfrozen):
		body.frozen = false
	body.cam.camfrozen = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func UpdateList():
	for n in listcont.get_children():
		n.queue_free()
	await get_tree().process_frame
	listheight = 50 * invlist.size()
	var totalweightnumber : float = 0.0
	if(invlist.size() > 0):
		for n in invlist:
			totalweightnumber += n.weight
			var it = item.instantiate()
			listcont.add_child(it)
			it.setup(n.name)
			it.entered.connect(display.bind(n))
			it.entered.connect(checkhighlight.bind(it))
		listcont.get_child(0)._on_focus_entered()
	currentweight = totalweightnumber
	totalweight.text = ("%.1f" % currentweight) + " / " + ("%.1f" % maxweight)

func checkhighlight(item):
	for n in listcont.get_children():
		n.highlight(n == item)

func display(obj : InventoryObject):
	selected = obj
	if(obj != null):
		itemicon.texture = obj.icon
		item_name.text = obj.name
		item_desc.text = obj.description
		#if(!obj.customproperties.is_empty()):
		#	for n in obj.customproperties:
		#		if(obj.customproperties[n] is float):
		#			item_desc.text += "\n" + str(n) + ": " + ("%.1f" % obj.customproperties[n])
		#		elif(obj.customproperties[n] is int):
		#			item_desc.text += "\n" + str(n) + ": " + str(obj.customproperties[n])
		#		elif(obj.customproperties[n] is bool):
		#			item_desc.text += "\n" + str(n) + ": " + ("yes" if (obj.customproperties[n]) else "no")
		itemweight.text = "%.1f" % obj.weight
	else:
		itemicon.texture = null
		item_name.text = ""
		item_desc.text = ""
		itemweight.text = "0.0"
