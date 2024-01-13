extends CharacterBody2D

@export var speed = 400
@onready var screen_size = get_viewport_rect().size
@onready var POWERUP_NODE = preload("res://scene/powerup.tscn")

signal hit

const LASER = preload("res://scene/laser.tscn")
const ROTATION_SPEED = 15

var last_direction = Vector2.DOWN
var target_angle : float
var shoot_right = false

func _ready():
	$ShootTimer.wait_time = Globals.fire_rate
	
func _physics_process(delta):
	get_input(delta)

	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)

		var collider = collision.get_collider()

		if collider.is_in_group("mobs"):
			hide()
			$CollisionShape2D.set_deferred("disabled", true)
			#ajout game over ou baisse de vie


func shoot():
	var new_laser = LASER.instantiate()
	var weapon = %ShootingPointLExt
	
	if shoot_right == false:
		weapon = %ShootingPointRExt
		shoot_right = true
	else:
		shoot_right = false
	
	var starting_position = weapon.global_position
	
	var dir = last_direction.normalized()
	var _rotation = rad_to_deg(atan2(dir.y, dir.x))
	new_laser.start(starting_position, last_direction, _rotation)
	weapon.add_child(new_laser)



func get_input(delta):
	var input_direction = Input.get_vector("left", "right", "up", "down")
	#if we are moving

	if input_direction.length_squared() > 0:
		last_direction = input_direction.normalized()  
		
	#si le joueur quitte l'écran il ré apparait de l'autre côté
	position.x = wrapf(position.x, 0, screen_size.x)
	position.y = wrapf(position.y, 0, screen_size.y)
	velocity = input_direction * speed
	
	
	#rotate the player
	target_angle = Vector2.DOWN.angle_to(velocity)
	
	if velocity.length() > 0:
		rotation = lerp_angle(rotation, target_angle, delta * ROTATION_SPEED) 
	
	
func power_up():
	#speed += 25
	Globals.fire_rate -= 0.05
	$ShootTimer.wait_time = Globals.fire_rate
	print($ShootTimer.wait_time)
	pass


func _on_shoot_timer_timeout():
	shoot()
