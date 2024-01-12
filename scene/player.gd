extends CharacterBody2D

@export var speed = 400

const LASER = preload("res://scene/laser.tscn")

var last_direction = Vector2.RIGHT

func _physics_process(delta):
	get_input()
	look_at(self.global_position)
	move_and_slide()


func shoot():
	var new_laser = LASER.instantiate()
	$Node2D.add_child(new_laser)
		
	var starting_position = %ShootingPointLeftExt.global_position
	var dir = last_direction.normalized()
	var _rotation = rad_to_deg(atan2(dir.y, dir.x))
	new_laser.start(starting_position, last_direction, _rotation)



func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	#if we are moving
	if input_direction.length_squared() > 0:
		last_direction = input_direction.normalized()  

		
		
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






func _on_timer_timeout():
	shoot()
