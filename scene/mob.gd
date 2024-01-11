extends CharacterBody2D

@export var speed = 50
@onready var player = get_node("/root/Main/Player")

var health = 5


func _physics_process(delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * speed 
	move_and_slide()


func take_damage():
	health -= 1
	if health == 0:
		queue_free()
