extends Node2D

const TieFighter = preload("res://scene/tie_fighter.tscn")
const TieInterceptor = preload("res://scene/tie_interceptor.tscn")
const StarDestroyer = preload("res://scene/star_destroyer.tscn")

var spawnable = [TieFighter, TieInterceptor]


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$Player.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Globals.mob_hit == Globals.mob_per_round and get_tree().get_nodes_in_group("powerup").size() == 0 and Globals.round_count != Globals.round_boss_spawn:
		$MobTimer.stop()
		$RoundTimer.start()
		Globals.mob_count = 0
		Globals.mob_hit = 0
		Globals.round_count += 1
		get_node("HUD/RoundLabel").text = "Round : %s" % Globals.round_count
		Globals.mob_per_round += randi_range(2,4)
		if Globals.round_count >= Globals.round_boss_spawn:
			increase_speed_mobs()
		
		
	elif Globals.round_count == Globals.round_boss_spawn and !Globals.is_boss_defeated:
		$RoundTimer.start()
		if !get_node("star_destroyer"):
			$SoundEntering.play()
			var destroyer = StarDestroyer.instantiate()
			destroyer.position = $DestroyerStartPosition.global_position
			destroyer.rotation_degrees = -90
			add_child(destroyer)
			$MobTimer.wait_time = 3.0
			await get_tree().create_timer(1.0).timeout
			$MobTimer.start()
			
		
			


func _on_player_shoot(Laser, direction, location):
	var spawned_laser = Laser.instantiate()
	add_child(spawned_laser)
	spawned_laser.rotation = direction
	spawned_laser.position = location
	spawned_laser.velocity = spawned_laser.velocity.rotated(direction)


func _on_mob_timer_timeout():
	if !Globals.is_game_over:
		var spawn = spawnable[randi()%spawnable.size()].instantiate()
		var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
		mob_spawn_location.progress_ratio = randf()
		
		
		# Set the mob's direction perpendicular to the path direction.
		var direction = mob_spawn_location.rotation + PI / 2

		# Set the mob's position to a random location.
		spawn.position = mob_spawn_location.position

		# Spawn the mob by adding it to the Main scene.
		if Globals.mob_count < Globals.mob_per_round:
			add_child(spawn)
			Globals.mob_count += 1
	

	
func new_game():
	$Player.position = $StartPlayerPosition.position
	$Player.speed = Globals.player_speed
	$Player/ShootTimer.wait_time = Globals.fire_rate
	$Player.show()
	$StartTimer.start()
	$HUD.show_message("Get Ready")
	$HUD.reset_score()
	$StartMusic.stop()
	$PlayMusic.play()
	Globals.is_game_over = false
	$Player.disable_shoot = false

func game_over():
	$HUD.show_game_over()
	$RoundTimer.stop()
	Globals.is_game_over = true
	await get_tree().create_timer(1.0).timeout
	for enemy in get_tree().get_nodes_in_group("mobs"):
		enemy.queue_free()
	for powerup in get_tree().get_nodes_in_group("powerup"):
		powerup.queue_free()

func _on_round_timer_timeout():
	$MobTimer.start()

	
func increase_speed_mobs():
	Globals.speed_tie_fighter = Globals.speed_tie_fighter + 25
	Globals.speed_tie_interceptor = Globals.speed_tie_interceptor + 20
	Globals.fire_rate_tie = Globals.fire_rate_tie - 0.25


func _on_start_timer_timeout():
	$RoundTimer.start()

