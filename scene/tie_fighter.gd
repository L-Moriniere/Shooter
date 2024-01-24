extends CharacterBody2D

@export var speed = randi_range(80,180)
@onready var player = get_node("/root/Main/Player")
@onready var PowerUp = preload("res://scene/powerup.tscn")
@onready var Heart = preload("res://scene/heart.tscn")
const explosion = preload("res://scene/explosion.tscn") 

signal die
var health = Globals.tie_fighter_health

	

func _physics_process(delta):
	var direction = global_position.direction_to(player.global_position)
	rotation = position.angle_to_point(player.global_position)
	look_at(player.global_position)
	velocity = direction * speed 
	move_and_slide()


func take_damage():
	$HitAnimation.play("hit")
	$HitSound.play()
	health -= 1
	if health == 0:
		$DeathSound.play()
		Globals.mob_hit += 1
		Globals.score += 1
		get_node("/root/Main/HUD").update_score()
		var e = explosion.instantiate()
		add_child(e)
		e.play("default")
		$Explode.start()
		drop_item()
		await get_tree().create_timer(0.15).timeout
		hide()
		$CollisionShape2D.disabled = true


func drop_item():
	var random_number = randf()
	var proba = 0.4
	if random_number < proba:
		if Globals.health != 2 and get_tree().get_nodes_in_group("heart").size() == 0:
			var heart_instance = Heart.instantiate()
			heart_instance.position = position
			get_parent().add_child(heart_instance)
			heart_instance.gain_life.connect(get_node("/root/Main/Player").gain_heart)
		else :
			var powerup_instance = PowerUp.instantiate()
			powerup_instance.position = position
			get_parent().add_child(powerup_instance)
			powerup_instance.collected.connect(get_node("/root/Main/Player").power_up)



func _on_death_sound_finished():
	queue_free()
