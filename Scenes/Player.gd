extends KinematicBody2D

signal player_died

export var gravity : int = 3
export var thrust : int = 75
var motion : Vector2

func _ready():
	position = get_parent().find_node("PlayerSpawn").position


func _physics_process(delta):
	apply_gravity()
	flop()
	var collision = move_and_collide(motion * delta)
	
	# Checks for collision of the game boundary tilemap
	if collision:
		emit_signal("player_died")


func apply_gravity() -> void:
	motion.y += gravity


func flop() -> void:
	if Input.is_action_just_pressed("flop"):
		motion.y -= thrust
