extends CharacterBody2D

@export var speed = randi_range(120,220)
@onready var player = get_node("/root/Main/Player")
@onready var POWERUP_NODE = preload("res://scene/powerup.tscn")
const explosion = preload("res://scene/explosion.tscn") 

signal die
var health = 1


func _physics_process(delta):
	var direction = global_position.direction_to(player.global_position)
	rotation = position.angle_to_point(player.global_position)
	velocity = direction * speed 
	move_and_slide()


func take_damage():
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
	var proba = 0.3
	if random_number < proba:
		var powerup_instance = POWERUP_NODE.instantiate()
		powerup_instance.position = position
		get_parent().add_child(powerup_instance)
		powerup_instance.collected.connect(get_node("/root/Main/Player").power_up)



func _on_death_sound_finished():
	queue_free()
