extends "res://scripts/interactable.gd"

func _ready() -> void:
	interact_name = "[E] to Interact"
	is_interactable = true
	interact = Callable(self, "_on_interact")

func _on_interact():
	is_interactable = false
	$speedupaudio.play()
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.speed = 200
		self.hide()
		await get_tree().create_timer(5.0).timeout
		player.speed = 100
	self.queue_free()
