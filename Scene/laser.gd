extends Area2D

@export var speed = 1000
var velocity = Vector2()

func _physics_process(delta):
	#laser qui suit la direction de la position initiale
	position += velocity * delta

	
func start(_position, _direction, _rotation):
	position = _position
	velocity = _direction * speed
	rotation_degrees = _rotation 

	
func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage()
		queue_free()



func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
