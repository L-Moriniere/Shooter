extends CanvasLayer

signal start_game

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()


func reset_score():
	$RoundLabel.text = "Round 1"
	$MobKilled.text = "Ships destroyed : 0"

func show_game_over():
	$HealthSprite.play("0life")
	show_message("Game Over")
	reset_count()
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	
func update_score():
	$MobKilled.text = "Ships destroyed : %s" % Globals.score
	
	
func update_weapon_label():
	$WeaponLabel.text = "Weapon %s" % Globals.number_weapon 
	
func update_speed_label():
	$SpeedLabel.text = "Speed +" + str(Globals.label_speed) +"%"
	
func update_speed_fire_rate_label():
	$FireRateLabel.text = "Fire rate +" + str(Globals.label_fire_rate) +"%"
	
	
func reset_count():
	Globals.score = 0
	Globals.round_count = 1
	Globals.mob_count = 0
	Globals.mob_per_round = 1
	Globals.mob_hit = 0
	Globals.lvl_power = 1
	Globals.player_speed = 300
	Globals.health = 2
	Globals.fire_rate = 0.5
	Globals.number_weapon = 1
	Globals.label_speed = 0
	Globals.label_fire_rate
	Globals.is_boss_defeated = false
	Globals.round_boss_base = 4
	Globals.speed_tie_fighter = 100
	Globals.speed_tie_interceptor = 50
	Globals.fire_rate_tie = 3
	Globals.tie_fighter_health = 1
	Globals.tie_interceptor_health = 2
	Globals.destroyer_health = 50
	$WeaponLabel.text = "Weapon 1"
	$SpeedLabel.text = "Speed +0%"
	$FireRateLabel.text = "Fire rate +0%"
	
	
func _on_message_timer_timeout():
	$Message.hide()


func _on_start_button_pressed():
	$StartButton.hide()
	start_game.emit()

func play_die_sound():
	pass
