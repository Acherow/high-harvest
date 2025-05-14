extends WorldEnvironment

@export_range(0,2400,1) var timeofday : float = 1200.0
@export var simulate : bool = false
@export_range(0,120,1) var rateoftime : float = .1
@export var sunlightcurve : Curve
@export var moonlightcurve : Curve

@export var sun : DirectionalLight3D
@export var moon  : DirectionalLight3D

@export var stockscurve : Curve

@export_category("RAIN")
@export var rainobj : Node3D

@export var israining : bool = false
@export var cloudlerp : Vector2 = Vector2(0.5, 0.2)
@export var topgradient : Gradient
@export var bottomgradient : Gradient
var currain : float = 0

var curtick = 0

var sunenergy
var moonenergy


@onready var raintimer: Timer = $raintimer

func _ready() -> void:
	timeofday = Savedata.gamedata["timeofday"]
	israining = Savedata.gamedata["israining"]
	if(rainobj != null):
		raintimer.start(Savedata.gamedata["raintime"])
		rainobj.call_deferred("reparent",get_tree().get_first_node_in_group("player"))
		await get_tree().process_frame
		rainobj.position = Vector3.ZERO

func _process(delta):
	if(simulate):
		timeofday += rateoftime * delta
	if(timeofday >= 2400):
		passday()
	Savedata.gamedata["timeofday"] = timeofday
	Savedata.gamedata["playtime"] += delta
	Savedata.gamedata["israining"] = israining
	if(rainobj != null):
		Savedata.gamedata["raintime"] = raintimer.time_left
		rainobj.amount_ratio = snapped(currain, .1)
		environment.sky.sky_material.set_shader_parameter("day_top_color",topgradient.sample(currain))
		environment.sky.sky_material.set_shader_parameter("day_bottom_color",bottomgradient.sample(currain))
		environment.sky.sky_material.set_shader_parameter("clouds_cutoff",lerp(cloudlerp.x,cloudlerp.y,currain))
	if(israining):
		for n in get_tree().get_nodes_in_group("crop"):
			n.curwetness += delta * 1
		currain = lerp(currain,1.0,delta*.1)
		#currain = clamp(currain+(delta*.1), 0,1)
	else:
		currain = lerp(currain,0.0,delta*.1)
		#currain = clamp(currain-(delta*.1), 0,1)
	
	if(sun != null):
		sun.light_energy = sunlightcurve.sample(timeofday/2400)
		environment.ambient_light_energy = clamp(sunlightcurve.sample(timeofday/2400)*.2, 0.02,.5)
		sun.rotation_degrees.x = lerp(90,-270, timeofday / 2400)
	if(moon != null):
		moon.light_energy = moonlightcurve.sample(timeofday/2400)
		environment.volumetric_fog_density = moonlightcurve.sample(timeofday/2400)*.2

signal day
func passday():
	timeofday = 0
	Library.marketmutate()
	Savedata.gamedata["day"] += 1
	for n in Savedata.gamedata["stocks"]:
		var amt = Savedata.gamedata["daysales"][n]
		Savedata.gamedata["stocks"][n] += Savedata.gamedata["stocks"][n] * .25
		Savedata.gamedata["stocks"][n] -= amt * .05
		Savedata.gamedata["stocks"][n] = clamp(Savedata.gamedata["stocks"][n],0.5,2)
	
	Savedata.resetsales()
	day.emit()

func timetransition(t : float) -> String:
	var minutes = str(floor(t/60)).pad_zeros(2).pad_decimals(0)
	var seconds = str(fmod(t, 60)).pad_zeros(2).pad_decimals(0)
	
	return minutes + ":" + seconds


func _on_raintimer_timeout() -> void:
	israining = !israining
	raintimer.start(randi_range(100,1500))
