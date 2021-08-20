extends Node2D

var obstacle : PackedScene = preload("res://Scenes/Obstacle.tscn")
var obstacle_speed : int = 3
var score : int = 0

onready var top_spawn = $TopSpawn
onready var bottom_spawn = $BottomSpawn
onready var score_label = $UI/ScoreLabel
onready var spawn_timer = $SpawnTimer
onready var score_timer = $ScoreTimer
onready var final_score_label = $UI/Menu/FinalScoreLabel
onready var menu = $UI/Menu


func _ready():
	get_tree().paused = false
	randomize()
	generate_obstacle()

func generate_obstacle() -> void:
	var new_obstacle = obstacle.instance()
	
	# Decide if the obstacle spawns on top or bottom
	var obstacle_y_origin = randi() % 2
	if obstacle_y_origin == 0:
		new_obstacle.position = top_spawn.position
	else:
		new_obstacle.position = bottom_spawn.position
	
	# Pick a random y scale
	var y_scale = rand_range(10.0, 20.0)
	new_obstacle.scale.y = y_scale
	new_obstacle.obstacle_speed = obstacle_speed
	add_child(new_obstacle)


func _on_SpawnTimer_timeout():
	generate_obstacle()


func _on_ScoreTimer_timeout():
	score += 10
	score_label.text = "Score: " + str(score)
	
	# increases difficulty every 100 points by increasing obstacle speed
	if score % 100 == 0:
		obstacle_speed += 1
		
		# Ensures that the wait time never reaches zero
		if score_timer.wait_time >= 0.10:
			spawn_timer.wait_time -= 0.1
		else:
			spawn_timer.wait_time = 0.1


func _on_Player_player_died():
	get_tree().paused = true
	$CanvasModulate.color = Color(0.0, 0.0, 0.0, 1.0)
	score_label.hide()
	menu.show()
	final_score_label.text = "Score: " + str(score)


func _on_PlayAgainButton_pressed():
	get_tree().reload_current_scene()


func _on_QuitButton_pressed():
	get_tree().quit()
