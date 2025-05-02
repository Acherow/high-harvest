extends RigidBody3D
@onready var childshape: CollisionShape3D = $childshape
@onready var teenagershape: CollisionShape3D = $teenagershape
@onready var adultshape: CollisionShape3D = $adultshape
@onready var childmodel: Node3D = $child
@onready var teenagermodel: Node3D = $teenager
@onready var adultskeleton: Node3D = $adult
@onready var adultmodel: MeshInstance3D = $adult/Skeleton3D/cow
@onready var oldmodel: MeshInstance3D = $adult/Skeleton3D/oldcow
@onready var floorcast : ShapeCast3D = $floorcast
@onready var anim = $AnimationPlayer
@onready var audio = $audio

@export var adultsounds : Array[AudioStream]

const BLOOD = preload("res://prefabs/bloodsplatter.tscn")
const BLOOD2 = preload("res://prefabs/bloodparticles.tscn")
