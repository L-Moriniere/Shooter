extends Area2D

@export var speed = 400
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO

	if Input.is_action_pressed("move_right"):
		set_sprite_properties(-90, false, true)
		velocity.x += 1
	elif Input.is_action_pressed("move_left"):
		set_sprite_properties(90, false, false)
		velocity.x -= 1
	elif Input.is_action_pressed("move_down"):
		set_sprite_properties(0, false, false)
		velocity.y += 1
	elif Input.is_action_pressed("move_up"):
		set_sprite_properties(0, true, false)
		velocity.y -= 1
	elif Input.is_action_pressed("move_up") and Input.is_action_pressed("move_right"):
		velocity.x += 1
		velocity.y += 1
		set_sprite_properties(45, false, false)

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	
func set_sprite_properties(degrees: int,flip_vertical: bool,flip_horizontal: bool):
	$AnimatedSprite2D.rotation_degrees = degrees
	$AnimatedSprite2D.flip_v = flip_vertical
	$AnimatedSprite2D.flip_h = flip_horizontal
		
