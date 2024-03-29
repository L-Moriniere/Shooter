extends CharacterBody2D


@export var speed = randi_range(80,130)
const explosion = preload("res://scene/explosion.tscn") 

@onready var player = get_node("/root/Main/Player")
@onready var PowerUp = preload("res://scene/powerup.tscn")
@onready var Heart = preload("res://scene/heart.tscn")
@onready var LaserMob = preload("res://scene/laser_mobs.tscn")


var health = Globals.tie_interceptor_health
var disable_shoot : bool = false


func _ready():
	$ShootTimer.start()
	
	
func _physics_process(delta):
	var direction = global_position.direction_to(player.global_position)
	rotation = position.angle_to_point(player.global_position)
	look_at(player.global_position)
	velocity = direction * speed 
	move_and_slide()


func take_damage():
	health -= 1
	$HitAnimation.play("hit")
	$HitSound.play()
	if health == 0:
		$DeathSound.play()
		Globals.mob_hit += 1
		Globals.score += 1
		get_node("/root/Main/HUD").update_score()
		var e = explosion.instantiate()
		add_child(e)
		e.play("default")
		$Explode.start()
		disable_shoot=true
		await get_tree().create_timer(0.15).timeout
		hide()
		$CollisionShape2D.disabled = true

		
		
func shoot():
	spawnLaser(%ShootingPoint)
	

func spawnLaser(weapon):
	if !disable_shoot:
		var new_laser = LaserMob.instantiate()
		var starting_position = weapon.global_position
		var dir = global_position.direction_to(player.global_position)
		var _rotation = rad_to_deg(atan2(dir.y, dir.x))
		new_laser.start(starting_position, dir, _rotation)
		$ShootSound.play()
		weapon.add_child(new_laser)

func drop_item():
	var random_number = randf()
	var proba = 0.4
	if random_number < proba:
		if Globals.health != 2  and !get_node("/root/Main/Player/Heart"):
			var heart_instance = Heart.instantiate()
			heart_instance.position = position
			get_parent().add_child(heart_instance)
			heart_instance.gain_life.connect(get_node("/root/Main/Player").gain_heart)
		else :
			var powerup_instance = PowerUp.instantiate()
			powerup_instance.position = position
			get_parent().add_child(powerup_instance)
			powerup_instance.collected.connect(get_node("/root/Main/Player").power_up)
	



func _on_shoot_timer_timeout():
	shoot()



func _on_death_sound_finished():
	queue_free()
