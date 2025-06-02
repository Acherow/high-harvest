extends Node3D

@export var targetscene : int
@export var targetposition : Vector3
@export var targetrotation : Vector3

func enter(body):
	if(body is Player):
		ObjectManager.serializeall()
		#Savedata.gamedata["player"][5] = null
		#Savedata.gamedata["player"][6] = null
		Savedata.gamedata["playerscene"] = targetscene
		Savedata.gamedata["player"][0] = targetposition
		Savedata.gamedata["player"][1] = targetrotation
		#Savedata.save_data()
		get_tree().call_deferred("change_scene_to_file",Library.scenes[targetscene])
