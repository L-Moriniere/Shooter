extends CharacterBody2D

@export var speed = 50
const explosion = preload("res://scene/explosion.tscn") 
@onready var player = get_node("/root/Main/Player")

var health = 5


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


func _on_explode_timeout():
	queue_free()
