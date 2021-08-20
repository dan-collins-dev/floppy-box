extends Area2D

var obstacle_destructor : Node
var obstacle_speed : int = 3

func _ready():
	obstacle_destructor = get_parent().find_node("DestructionPosition", true)


func _physics_process(delta):
	position.x -= obstacle_speed
	if position.x < obstacle_destructor.position.x:
		queue_free()


func _on_Obstacle_body_entered(body):
	if body.name == "Player":
		body.emit_signal("player_died")
