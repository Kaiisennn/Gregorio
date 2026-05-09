extends Node2D

var enemy_scene = preload("res://enemy.tscn")
var score = 0
var high_score = 0

func _ready() -> void:
	randomize()
	reset_player_position()
	$Music.play()
	$Player.z_index = -1
	$CanvasLayer.layer = 10

func reset_player_position():
	var screen_size = get_viewport().get_size()
	var pos = Vector2(screen_size.x / 2, screen_size.y / 2)
	$Player.position = pos

func _on_player_body_entered(_body: Node2D) -> void:
	if not $Player.alive:
		return 
	
	$Music.stop()
	$Music.playing = false
	$Death.play()
	
	
	$Player.alive = false
	reset_player_position()
	$CanvasLayer/Start.visible = true
	$Timer.stop()
	$Timer/ScoreTimer.stop()
	
	for child in get_children():
		if child is RigidBody2D:
			child.queue_free()
	
	$CanvasLayer/HighScore.visible = true
	if high_score < score:
		high_score = score
		
	$CanvasLayer/HighScore.text = "High Score: " + str(high_score)

func _on_timer_timeout() -> void:
	var enemy = enemy_scene.instantiate()
	enemy.z_index = -1
	add_child(enemy)

func _on_start_pressed() -> void:
	$CanvasLayer/Start.visible = false
	
	var enemies_to_delete = []
	for child in get_children():
		if child is RigidBody2D:
			enemies_to_delete.append(child)
	
	for enemy in enemies_to_delete:
		enemy.queue_free()
	
	$Player.alive = true

	$CanvasLayer/HighScore.visible = false
	$CanvasLayer/Score.visible = false
	$CanvasLayer/Dodge.visible = true
	
	await get_tree().create_timer(0.8).timeout
	$CanvasLayer/Dodge.visible = false
	
	$CanvasLayer/Score.visible = true
	score = 0
	$CanvasLayer/Score.text = "0"
	$Timer/ScoreTimer.start()
	
	$Timer.wait_time = 1.1
	$Timer.start()
	
	if not $Music.playing: $Music.play()

func _on_score_timer_timeout() -> void:
	score += 1
	$CanvasLayer/Score.text = str(score)
