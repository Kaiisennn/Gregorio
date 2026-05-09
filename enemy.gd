extends RigidBody2D

func _ready() -> void:
	randomize()
	var enemy_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.animation = enemy_types[randi() % enemy_types.size()]
	
	var screen = get_viewport_rect().size
	var side = randi() % 4
	
	if side == 0:
		position = Vector2(randf() * screen.x, -40)
	elif side == 1:
		position = Vector2(randf() * screen.x, screen.y + 40)
	elif side == 2:
		position = Vector2(-40, randf() * screen.y)
	else:
		position = Vector2(screen.x + 40, randf() * screen.y)
	
	var target = Vector2(randf() * screen.x, randf() * screen.y)
	var direction = (target - position).normalized()
	var speed = randf_range(160, 220)
	linear_velocity = direction * speed
	rotation = direction.angle()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _body_entered(body: Node) -> void:
	if body is RigidBody2D:
		return
