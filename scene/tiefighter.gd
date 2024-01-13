extends CharacterBody2D

@export var speed = randi_range(100,200)
const explosion = preload("res://scene/explosion.tscn") 


@onready var player = get_node("/root/Main/Player")
@onready var POWERUP_NODE = preload("res://scene/powerup.tscn")

var health = 1


func _physics_process(delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * speed 
	move_and_slide()


func take_damage():
	health -= 1
	if health == 0:
		Globals.mob_hit += 1
		var e = explosion.instantiate()
		add_child(e)
		e.play("default")
		$explode.start()
		drop_item()
		


func _on_explode_timeout():
	queue_free()

func drop_item():
	var random_number = randf()
	var proba = 0.3
	if random_number < proba:
		var powerup_instance = POWERUP_NODE.instantiate()
		powerup_instance.position = position
		get_parent().add_child(powerup_instance)
		powerup_instance.collected.connect(get_node("../Player").power_up)

