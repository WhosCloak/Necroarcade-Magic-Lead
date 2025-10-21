extends RigidBody2D

@export var damage := 1

func _ready():
	await get_tree().create_timer(2.0).timeout
	queue_free()

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("enemy"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
		queue_free()
