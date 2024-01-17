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
	$RoundLabel.text = "Score : 1"

func show_game_over():
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout
	reset_count()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	
	
	
func reset_count():
	Globals.round_count = 1
	Globals.mob_count = 0
	Globals.mob_per_round = 1
	Globals.mob_hit = 0
	Globals.lvl_power = 1
	Globals.fire_rate = 0.3
	Globals.number_weapon = 1
	Globals.is_boss_defeated = false

func _on_message_timer_timeout():
	$Message.hide()


func _on_start_button_pressed():
	$StartButton.hide()
	start_game.emit()
