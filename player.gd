extends Area2D


var speed = 400
var screen_size

var alive = false

func _ready():
	screen_size = get_viewport_rect().size


func _process(delta):
	if not alive:
		$AnimatedSprite2D.stop()
		return
		
	var velocity = Vector2.ZERO
	
	if Input.is_action_pressed("move_down"):
		velocity.y +=1
	if Input.is_action_pressed("move_up"):
		velocity.y -=1
	if Input.is_action_pressed("move_left"):
		velocity.x -=1
	if Input.is_action_pressed("move_right"):
		velocity.x +=1
	
	if velocity != Vector2.ZERO:
		var direction = velocity.normalized()
		
		position = position + direction * speed * delta
		position.x = clamp(position.x, 0, screen_size.x)
		position.y = clamp(position.y, 0, screen_size.y)
		
		$AnimatedSprite2D.play ()
	else:
		$AnimatedSprite2D.stop()
		
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	if velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0
		$AnimatedSprite2D.flip_h = false
		
