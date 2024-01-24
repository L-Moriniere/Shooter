extends Node2D

const TieFighter = preload("res://scene/tie_fighter.tscn")
const TieInterceptor = preload("res://scene/tie_interceptor.tscn")
const StarDestroyer = preload("res://scene/star_destroyer.tscn")

var spawnable = [TieFighter, TieInterceptor]

var health = Globals.health

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$Player.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	printt(Globals.tie_fighter_health, Globals.tie_interceptor_health, Globals.round_boss_spawn, Globals.fire_rate_tie, Globals.spawn_mobs)
	if Globals.is_boss_defeated:
		Globals.spawn_mobs = false
		if get_tree().get_nodes_in_group("mobs").size() == 0:
			Globals.round_boss_spawn += randi_range(2,4)
			Globals.is_boss_defeated = false
			Globals.is_round_finished = true
		
	if Globals.mob_hit == Globals.mob_per_round:
		Globals.is_round_finished = true

		
	if Globals.is_round_finished:
		print("round finished : %s"% Globals.round_count) 
		Globals.is_round_finished = false
		Globals.spawn_mobs = false
		Globals.mob_count = 0
		Globals.mob_hit = 0
		update_round()
		Globals.mob_per_round += randi_range(2,4)
		Globals.mob_count_last_round = Globals.mob_per_round 
		if Globals.round_count >= Globals.round_boss_spawn:
			increase_difficulty_mobs()
		start_round()
	
		
	

	
		
		
		
func start_round():
	$RoundTimer.start()
	if Globals.round_count == Globals.round_boss_spawn:
			spawn_star_destroyer()
		

func update_round():
	Globals.round_count += 1
	get_node("HUD/RoundLabel").text = "Round %s" % Globals.round_count
	
	
func _on_player_shoot(Laser, direction, location):
	var spawned_laser = Laser.instantiate()
	add_child(spawned_laser)
	spawned_laser.rotation = direction
	spawned_laser.position = location
	spawned_laser.velocity = spawned_laser.velocity.rotated(direction)


func _on_mob_timer_timeout():
	print("ok")
	if !Globals.is_game_over and Globals.spawn_mobs:
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
	
func spawn_star_destroyer():
	if !get_node("star_destroyer") and Globals.round_count == Globals.round_boss_spawn and !Globals.is_boss_defeated:
		$SoundEntering.play()
		var destroyer = StarDestroyer.instantiate()
		destroyer.position = $DestroyerStartPosition.global_position
		destroyer.rotation_degrees = -90
		add_child(destroyer)
		$RoundTimer.start()
	
func new_game():
	$Player/CollisionShape2D.disabled = false
	$Player.position = $StartPlayerPosition.position
	$Player.speed = Globals.player_speed
	$Player/ShootTimer.wait_time = Globals.fire_rate
	$Player.show()
	$StartTimer.start()
	$HUD.show_message("Get Ready")
	$HUD.reset_score()
	$HUD/HealthSprite.play("2life")
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
	for powerup in get_tree().get_nodes_in_group("collectable"):
		powerup.queue_free()

func _on_round_timer_timeout():
	Globals.is_round_finished = false
	Globals.spawn_mobs = true
	$MobTimer.start()



	
func increase_difficulty_mobs():
	Globals.speed_tie_fighter += 25
	Globals.speed_tie_interceptor += 20
	Globals.fire_rate_tie -= 0.25
	Globals.tie_fighter_health += 1
	Globals.tie_interceptor_health += 2
	Globals.destroyer_health += 30



func _on_start_timer_timeout():
	$RoundTimer.start()



func _on_play_music_finished():
	$PlayMusic.play()
