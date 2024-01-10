extends CharacterBody2D


const SPEED = 300.0

@export var speed = 400

var last_direction = Vector2.ZERO

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")


	#if we are moving
	if input_direction.length_squared() > 0:
		
		if input_direction.x != 0 and input_direction.y != 0:

			if input_direction.y > 0:
				if input_direction.x > 0:
					$AnimatedSprite2D.animation = "down_right" 
				else: 
					$AnimatedSprite2D.animation = "down_left" 
			else: 
				if input_direction.x > 0:
					$AnimatedSprite2D.animation = "up_right"
				else: 
					$AnimatedSprite2D.animation = "up_left"
		elif input_direction.x != 0:
			if input_direction.x > 0:
				$AnimatedSprite2D.animation = "right"
			else:
				$AnimatedSprite2D.animation = "left"
		elif input_direction.y != 0:
			if input_direction.y > 0:
				$AnimatedSprite2D.animation = "down"
			else:
				$AnimatedSprite2D.animation = "up"

	velocity = input_direction * speed

func _physics_process(delta):
	get_input()
	move_and_slide()
