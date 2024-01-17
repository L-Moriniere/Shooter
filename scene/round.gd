extends Node2D

const TieFighter = preload("res://scene/tie_fighter.tscn")
const TieInterceptor = preload("res://scene/tie_interceptor.tscn")
const StarDestroyer = preload("res://scene/star_destroyer.tscn")

var spawnable = [TieFighter, TieInterceptor]

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_player_shoot(Laser, direction, location):
	var spawned_laser = Laser.instantiate()
	add_child(spawned_laser)	
	spawned_laser.rotation = direction
	spawned_laser.position = location
	spawned_laser.velocity = spawned_laser.velocity.rotated(direction)


func _on_mob_timer_timeout():
	var spawn = spawnable[randi()%spawnable.size()].instantiate()
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.progress_ratio = randf()
	
	
	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	spawn.position = mob_spawn_location.position


	
	
	
