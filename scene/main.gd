extends Node2D

const MOB = preload("res://scene/tiefighter.tscn")



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


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
	var new_mob = MOB.instantiate()
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.progress_ratio = randf()
	
	
	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	new_mob.position = mob_spawn_location.position



	# Choose the velocity for the mob.

	# Spawn the mob by adding it to the Main scene.
	if Globals.mob_count < Globals.mob_per_round:
		add_child(new_mob)
		Globals.mob_count += 1
	
	if Globals.mob_hit == Globals.mob_per_round:
		Globals.mob_count = 0
		Globals.mob_hit = 0
		Globals.round += 1
		Globals.mob_per_round += randi_range(2,4)
		print(str(Globals.mob_hit) + " - " + str(Globals.mob_count) + " - " + str(Globals.mob_per_round))
		get_tree().reload_current_scene()
	#elif Globals.mob_count == Globals.mob_per_round and 
	
