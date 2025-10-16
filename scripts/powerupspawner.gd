extends Node2D
var speedup = preload("res://scenes/speedup.tscn")
var maxammo = preload("res://scenes/maxammo.tscn")


# Spawn tuning 
var spawn_distance = 500 
var spawn_interval = 15
var timer := 0.0 
var player: Node2D 

func _ready():
	player = get_tree().get_first_node_in_group("player")

func _process(delta):
	# simple timer, spawn on interval
	timer += delta
	if timer >= spawn_interval:
		timer = 0
		spawn_powerup()

func spawn_powerup():
	if not player:
		return
	var direction = Vector2(randf() * 2 - 1, randf() * 2 - 1).normalized()
	var spawn_pos = player.global_position + direction * spawn_distance

	var powerups = [speedup, maxammo, speedup]
	var poweruprandomizer = powerups[randi() % powerups.size()]
	 
	var spawnpowerup = poweruprandomizer.instantiate()
	spawnpowerup.global_position = spawn_pos
	get_parent().add_child(spawnpowerup)
