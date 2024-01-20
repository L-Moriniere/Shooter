extends Area2D

signal collected



func _physics_process(delta):
	pass


func _on_body_entered(body):
	if body.is_in_group("player"):
		$PowerUpSound.play()
		emit_signal("collected")
		hide()
		$CollisionShape2D.disabled = true


func _on_power_up_sound_finished():
	queue_free()
