extends CharacterBody2D

@onready var start_position = get_node("/root/Main/DestroyerStartPosition")
@onready var end_position = get_node("/root/Main/DestroyerEndPosition")
const TieFighter = preload("res://scene/tie_fighter.tscn")
const TieInterceptor = preload("res://scene/tie_interceptor.tscn")
const explosion = preload("res://scene/explosion.tscn") 


var spawnable = [TieFighter, TieInterceptor]
var spawn_positions = [$Spawn1, $Spawn2]

var health = Globals.tie_interceptor_health
@export var speed = 50


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

func _physics_process(delta):
	var direction = global_position.direction_to(end_position.global_position)
	velocity = direction * speed 
	move_and_slide()


func _on_spawn_timer_timeout():
	var spawn = spawnable[randi()%spawnable.size()].instantiate()
	var proba = randf()
	if proba > 0.5:
		spawn.position = $Spawn1.position
	else : 
		spawn.position = $Spawn2.position
	add_child(spawn)
	
	
func take_damage():
	health -= 1
	$HitAnimation.play("hit")
	$HitSound.play()
	if health == 0:
		Globals.round_boss_base = Globals.round_boss_base + randi_range(2,4)
		Globals.score += 10
		Globals.is_boss_defeated = true
		get_node("/root/Main/HUD").update_score()
		var e = explosion.instantiate()
		e.scale.x = 10
		e.scale.y = 10
		add_child(e)
		e.play("default")
		$Explode.start()



func _on_explode_timeout():
	queue_free()
