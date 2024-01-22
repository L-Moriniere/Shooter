extends Area2D

signal collected

func _on_body_entered(body):
	$CollisionShape2D.disabled = true
	if body.is_in_group("player"):
		queue_free()
		emit_signal("collected")
	
