extends Node2D

var enemy_scene_1 = preload("res://scenes/enemy1.tscn")
var enemy_scene_2 = preload("res://scenes/enemy2.tscn")

var spawn_distance = 500
var spawn_interval = 2.0
var timer := 0.0
var player: Node2D

func _ready():
	player = get_tree().get_first_node_in_group("player")

func _process(delta):
	timer += delta
	if timer >= spawn_interval:
		timer = 0
		spawn_enemy()

func spawn_enemy():
	if not player:
		return

	var direction = Vector2(randf() * 2 - 1, randf() * 2 - 1).normalized()
	var spawn_pos = player.global_position + direction * spawn_distance

	var enemy_scenes = [enemy_scene_1, enemy_scene_2]
	var enemy_scene = enemy_scenes[randi() % enemy_scenes.size()]

	var enemy = enemy_scene.instantiate()
	enemy.global_position = spawn_pos
	get_tree().current_scene.add_child(enemy)
