extends CharacterBody2D


@export var speed = randi_range(50,150)
const explosion = preload("res://scene/explosion.tscn") 

@onready var player = get_node("/root/Main/Player")
@onready var POWERUP_NODE = preload("res://scene/powerup.tscn")
@onready var LaserMob = preload("res://scene/laser_mobs.tscn")


var health = 5


func _physics_process(delta):
	var direction = global_position.direction_to(player.global_position)
	rotation = position.angle_to_point(player.global_position)
	look_at(player.global_position)
	velocity = direction * speed 
	move_and_slide()


func take_damage():
	health -= 1
	if health == 0:
		Globals.mob_hit += 1
		var e = explosion.instantiate()
		add_child(e)
		e.play("default")
		$Explode.start()
		drop_item()
		
func shoot():
	spawnLaser(%ShootingPoint)
	

func spawnLaser(weapon):
	var new_laser = LaserMob.instantiate()
	var starting_position = weapon.global_position
	var dir = global_position.direction_to(player.global_position)
	var _rotation = rad_to_deg(atan2(dir.y, dir.x))
	new_laser.start(starting_position, dir, _rotation)
	weapon.add_child(new_laser)

func _on_explode_timeout():
	queue_free()

func drop_item():
	var random_number = randf()
	var proba = 0.2
	if random_number < proba:
		var powerup_instance = POWERUP_NODE.instantiate()
		powerup_instance.position = position
		get_parent().add_child(powerup_instance)
		powerup_instance.collected.connect(get_node("../Player").power_up)



func _on_shoot_timer_timeout():
	shoot()
	print("ojk")