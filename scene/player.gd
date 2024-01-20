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
var disable_shoot : bool = true

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
			hit.emit()




func shoot():
	if !disable_shoot:
		match (Globals.number_weapon):
			1:
				var weapon = %ShootingPointLExt
				if shoot_right == false:
					weapon = %ShootingPointRExt
					shoot_right = true
				else:
					shoot_right = false
		
				spawnLaser(weapon)
			2:
				var weapon1 = %ShootingPointLExt
				var weapon2 = %ShootingPointRExt
				spawnLaser(weapon1)
				spawnLaser(weapon2)
				
			3:
				var weapon1 = %ShootingPointLExt
				var weapon2 = %ShootingPointRExt
				var weapon3 = %ShootingPointLInt
				spawnLaser(weapon1)
				spawnLaser(weapon2)
				spawnLaser(weapon3)
			4:
				var weapon1 = %ShootingPointLExt
				var weapon2 = %ShootingPointRExt
				var weapon3 = %ShootingPointLInt
				var weapon4 = %ShootingPointRInt
				spawnLaser(weapon1)
				spawnLaser(weapon2)
				spawnLaser(weapon3)
				spawnLaser(weapon4)

		

func spawnLaser(weapon):
	var new_laser = LASER.instantiate()
	var starting_position = weapon.global_position
	var dir = last_direction.normalized()
	var _rotation = rad_to_deg(atan2(dir.y, dir.x))
	new_laser.start(starting_position, last_direction, _rotation)
	$ShootSound.play()
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
	$PowerUpSound.play()
	var array = [1,2,3]
	var item = array[randi() % array.size()] 
	match item:
		1:
			speed += 20
			Globals.label_speed += 5
			get_node('/root/Main/HUD').update_speed_label()
		2:
			if Globals.fire_rate > 0.001 :
				Globals.fire_rate -= 0.05
			elif Globals.fire_rate == 0.05:
				Globals.fire_rate == 0.001
			$ShootTimer.wait_time = Globals.fire_rate
			Globals.label_fire_rate += 5
			get_node('/root/Main/HUD').update_speed_fire_rate_label()
		3: 
			if Globals.number_weapon <4:
				Globals.number_weapon += 1
				get_node('/root/Main/HUD').update_weapon_label()
			


func _on_shoot_timer_timeout():
	shoot()


func _on_hit():
	disable_shoot = true
	$ShootTimer.wait_time = Globals.fire_rate
	$DeathSound.play()
